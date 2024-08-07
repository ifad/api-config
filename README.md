
[![Build Status](https://github.com/ifad/api-config/actions/workflows/ruby.yml/badge.svg)](https://github.com/ifad/api-config/actions)

# Api::Config

A simple way to maintain configurations in a Ruby project using YAML file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api-config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api-config

## Usage

```Ruby
APIConfig.foo
APIConfig.bar.goo
```

## Ruby 3.0.x

An issue with the `ostruct` version shipped with Ruby 3.0.x does not allow
`Api::Config` to work properly.

If you are using Ruby 3.0.x, please add to your Gemfile

```rb
gem 'ostruct', '> 0.3.1'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/api-config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
