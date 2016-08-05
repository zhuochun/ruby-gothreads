#!/usr/bin/env ruby
# encoding: utf-8

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ruby_go"

include RubyGo

c = chan()
timeout = RubyGo::Timeout.new(5)

p Time.now()

go do
  sleep 20
  c << true
end

select({
  c => ->(result) { p "Result: #{result}" },
  timeout => ->(_) { p "Timeout" }
})

p Time.now()
