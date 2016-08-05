# RubyGo

Syntax sugars (`go`, `chan` and `select`) around Ruby threads, emulating Golang Goroutines.

## Usage

``` ruby
include RubyGo

c = chan()
timeout = RubyGo::Timeout.new(5)

go { sleep 20; c << true }

select({
  c => ->(result) { p "Result: #{result}" },
  timeout => ->(_) { p "Timeout" }
})
```

Refer to more examples in `example`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_gothreads'
```

## License

MIT 2016 @ [Zhuochun](https://github.com/zhuochun).
