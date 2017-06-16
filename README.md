# mruby-plato-timer   [![Build Status](https://travis-ci.org/mruby-plato/mruby-plato-timer.svg?branch=master)](https://travis-ci.org/mruby-plato/mruby-plato-timer)
Plato::Timer class (timer library)
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-machine'
  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-timer'
end
```

## example
```ruby
ary = []
Plato::Timer.add(1000, Proc.new {|a| a << 1}, ary)
Plato::Timer.start
loop {
  p ary
  Plato::Timer.refresh
  Plato::Machine.delay(1)
}
```

## License
under the MIT License:
- see LICENSE file
