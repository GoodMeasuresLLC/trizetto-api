# Trizetto::Api

Ruby wrapper for Trizetto APIs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trizetto-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trizetto-api

## Usage

### Use the Eligibility Web Service with an XML payload to check eligibility in realtime

This uses name/value pairs in a request and returns an XML docunment as a response.
You can force this API to return an X12 document if you like pain.

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = 'Not the real username'
  config.password = 'Super Top Secret'
end


client = Trizetto::Api::Eligibility::WebService.new({
  pretty_print_xml: true,
  log: true,
  log_level: :debug,
})
response = client.do_inquiry({
  'ProviderLastName': 'BLUE CROSS BLUE SHIELD OF MASSACHUSETTS',
  'NPI':              'YOUR NPI HERE',
  'InsuredFirstName': 'Mickey',
  'InsuredLastName':  'Mouse',
  'InsuredDob':       '19281118',
  'GediPayerId':      'N4222',
})

puts response.to_hash[:do_inquiry_response][:do_inquiry_result][:success_code]

source = response.to_hash[:do_inquiry_response][:do_inquiry_result][:response_as_xml]
puts Nokogiri::XML(source).to_xml
```


### Use the CORE2 API with an X12 payload to check eligibility in realtime

This returns an X12/271 response.  You will need to understand how to build
X12/270 requests and parse X12/271 responses.

```ruby

require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = 'Not the real username'
  config.password = 'Super Top Secret'
end


client = Trizetto::Api::Eligibility::Core2.new
client.check_eligibility(payload: x12_message)
```

### Ping the Payer List endpoint to see if it is up

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = 'Not the real username'
  config.password = 'Super Top Secret'
end

client = Trizetto::Api::PayerList::WebService.new({
  pretty_print_xml: true,
  log: true,
  log_level: :debug,
})

response = client.ping
```

### Fetch the Payer List

This API times out or errors out on the Trizetto server.  But you may get it to work.

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = 'Not the real username'
  config.password = 'Super Top Secret'
end

client = Trizetto::Api::PayerList::WebService.new({
  pretty_print_xml: true,
  log: true,
  log_level: :debug,
  read_timeout: 60*5 # 5 minutes
})

response = client.payer_list

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GoodMeasuresLLC/trizetto-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Trizetto::Api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/GoodMeasuresLLC/trizetto-api/blob/master/CODE_OF_CONDUCT.md).
