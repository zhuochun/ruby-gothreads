require "thread"

require "ruby_go/version"
require "ruby_go/timeout"

module RubyGo
  # go starts a thread
  def go(&block)
    Thread.new(&block)
  end

  # chan creates a size channel with default size 1
  def chan(len = 1)
    SizedQueue.new(len)
  end

  # select receives a { chan => action } map, and blocked til a chan to execute
  def select(chans)
    chan_method = ->(_) {}
    value = nil

    selected = false
    loop do
      chans.each do |c, cm|
        begin
          value = c.pop(true)
          chan_method = cm
          selected = true
          break
        rescue ThreadError
        end
      end

      break if selected
    end

    chan_method.call(value)
  end
end
