# Trizetto::Api

[![Build Status](https://travis-ci.org/GoodMeasuresLLC/trizetto-api.svg?branch=master)](https://travis-ci.org/GoodMeasuresLLC/trizetto-api)

Ruby wrapper for Trizetto APIs for Ruby 2.3 and above.

## Installation

<b>Requires Ruby 2.3 or above</b>

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

To simply check if the patient is covered by a health plan

```ruby
GENERAL_HEALTH_PLAN_COVERAGE_CODE = "30"
response = client.do_inquiry({...})
response.active_coverage_for?(GENERAL_HEALTH_PLAN_COVERAGE_CODE)  #=> true | false
```

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = 'Not the real username'
  config.password = 'Super Top Secret'
end

client = Trizetto::Api::Eligibility::WebService::Client.new({
  # You probably don't want logging enable unless you are being very careful to protect PHI in logs
  # pretty_print_xml: true,
  # log: true,
  # log_level: :debug,
})

response = client.do_inquiry({
  'ProviderLastName': 'BLUE CROSS BLUE SHIELD OF MASSACHUSETTS',
  'NPI':              'YOUR NPI HERE',
  'InsuredFirstName': 'Mickey',
  'InsuredLastName':  'Mouse',
  'InsuredDob':       '19281118',
  'GediPayerId':      'N4222',
})

# Were there validation errors with the request?
response.success?                                          # => false
response.success_code                                      # => "ValidationFailure"
response.errors.messages                                   # => ["Please enter InsuranceNum."]response.errors.validation_failures.first.affected_fields  # => ["InsuranceNum"]
response.errors.validation_failures.first.message          # => "Please enter InsuranceNum."


# Did we successfully get back an eligibility response from the payer.
response.success?                   # => true
response.success_code               # => "Success"
response.transaction_id             # => "c6eb40c5584f0496be3f3a48d0ddfd"
response.payer_name                 # => "BLUE CROSS BLUE SHIELD OF MASSACHUSETTS"
response.active_coverage_for?("30") # => true

# Was the response rejected? We got back an eligibility response, but probably the patient wasn't found
response.success?                           # => true
response.success_code                       # => "Success"
response.active_coverage_for?("30")         # => false
response.rejected?                          # => true
response.rejectsions.count                  # => 1
response.rejectsions.first.reason           # => "Patient Birth Date Does Not Match That for the Patient on the Database"
response.rejectsions.first.follow_up_action # => "Please Correct and Resubmit"

# What active insurance coverages of service_type_code=30 does this patient have?
coverages = response.patient.benefits.select {|benefit| benefit.active_coverage? && benefit.service_type_codes.include?("30")}
coverages.count                # => 2
coverages.first.insurance_type # => "Preferred Provider Organization (PPO)"
coverages.last.insurance_type  # => "Medicare Part A"
coverages.first.messages       # => nil
coverages.last.messages        # => ["BCBSMA IS PRIME"]

# Find all the benefit information for service_type_code=30
benefits = response.patient.benefits.select {|benefit| benefit.service_type_codes.include?("30")}

benefits.map(&:info).uniq # => ["Active Coverage", "Deductible", "Coverage Basis", "Out of Pocket (Stop Loss)", "Services Restricted to Following Provider"]

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
