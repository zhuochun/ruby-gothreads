#!/usr/bin/env ruby
# encoding: utf-8

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ruby_go"

include RubyGo

nums_chan = chan(8)

wg = []

wg << go do
  x, y = 1, 1

  4.times do
    sleep 0.2
    nums_chan << "1 - #{y}"
    x, y = y, x + y
  end
end

wg << go do
  x, y = 1, 1

  4.times do
    sleep 0.8
    nums_chan << "2 - #{y}"
    x, y = y, x + y
  end
end

8.times do
  p nums_chan.pop
end

wg.map(&:join)
