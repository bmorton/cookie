# Cookie

`Cookie` is a Ruby client for the Girl Scouts DigitalCookie API.  Digital Cookie is the official platform for managing sales of Girl Scout cookies.  This client provides an excellent way to teach Girl Scouts about programming in a domain they are familiar with.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add cookie
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install cookie
```

## Usage

```ruby
client = Cookie::Client.authenticate(
  username: "juliette@example.com",
  credential: "daisy"
)

client.orders.get_hand_delivery("troop-31337")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bmorton/cookie. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cookie/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cookie project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cookie/blob/main/CODE_OF_CONDUCT.md).
