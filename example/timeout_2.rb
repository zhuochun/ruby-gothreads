#!/usr/bin/env ruby
# encoding: utf-8

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "logger"
require "ruby_go"

include RubyGo

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO

class Task
  include RubyGo

  def initialize(name)
    @name = name
  end

  def do
    sleep_sec = rand() * 30
    timeout_sec = rand() * 30

    c = chan()
    t = RubyGo::Timeout.new(timeout_sec)

    go do
      sleep sleep_sec
      c << true
    end

    select({
      c => ->(result) do
        correct = sleep_sec <= timeout_sec
        LOGGER.info "[#{@name}][#{correct}] RESULT: #{sleep_sec}, Timeout: #{timeout_sec}"
      end,
      t => ->(_) do
        correct = timeout_sec <= sleep_sec
        LOGGER.info "[#{@name}][#{correct}] timeout: #{timeout_sec}, Sleep: #{sleep_sec}"
      end
    })
  end
end

LOGGER.info "Starting"

wg = 100.times.map do |i|
  go { Task.new("Task #{i}").do }
end

wg.map(&:join)

LOGGER.info "Finished"
