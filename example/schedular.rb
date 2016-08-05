#!/usr/bin/env ruby
# encoding: utf-8

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "logger"
require "ruby_go"

include RubyGo

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO

ExitException = Class.new(StandardError)

Task = Struct.new(:name, :result)

NUM_WORKERS = 5
NUM_TASKS = 25

task_chan = chan(NUM_WORKERS)
done_chan = chan(NUM_WORKERS)
exit_chan = chan(NUM_WORKERS)

def worker(worker_id, task_chan, done_chan, exit_chan)
  -> do
    LOGGER.info "Worker #{worker_id} Started"

    begin
      loop do
        select({
          task_chan => ->(task) do
            LOGGER.info "[#{worker_id}] Start #{task.name}"
            task.result = rand()
            sleep task.result
            done_chan << task
            LOGGER.info "[#{worker_id}] Finished #{task.name}"
          end,
          exit_chan => ->(_) { raise ExitException },
        })
      end
    rescue ExitException
    end

    LOGGER.info "Worker #{worker_id} Ended"
  end
end

wg = NUM_WORKERS.times.map do |i|
  go(&worker(i, task_chan, done_chan, exit_chan))
end

wg << go do
  LOGGER.info "Producer Started"
  NUM_TASKS.times { |i| task_chan << Task.new("Task #{i}") }
  LOGGER.info "Producer Ended"
end

wg << go do
  LOGGER.info "Consumer Started"
  NUM_TASKS.times do
    task = done_chan.pop
    LOGGER.info "Consumer Read #{task.name}, Result #{task.result}"
  end
  LOGGER.info "Consumer Ended"

  LOGGER.info "Consumer Signal Exit Start"
  NUM_WORKERS.times { exit_chan << true }
  LOGGER.info "Consumer Signal End Start"
end

wg.map(&:join)
