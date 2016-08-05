# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_go/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_go"
  spec.version       = RubyGo::VERSION
  spec.authors       = ["Zhuochun"]
  spec.email         = ["zhuochun@hotmail.com"]

  spec.summary       = %q{Syntax sugars around Ruby threads like Goroutines}
  spec.description   = %q{Syntax sugars (`go`, `chan`, `select`) around Ruby threads and queues, emulating Golang Goroutines}
  spec.homepage      = "https://github.com/zhuochun"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
