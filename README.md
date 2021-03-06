# Trizetto::Api

[![Build Status](https://travis-ci.org/GoodMeasuresLLC/trizetto-api.svg?branch=master)](https://travis-ci.org/GoodMeasuresLLC/trizetto-api)

Ruby wrapper for Trizetto APIs for Ruby 2.3 and above.

## Installation

<b>Requires Ruby 2.3 or above</b>

Add this line, and maybe some others, to your application's Gemfile:

```ruby
gem 'trizetto-api'

# Savon-multipart is used in the CORE II API. savon-multipart 2.1.1 has the
# mail gem, pinned to exactly 2.5.4.  As of Jan 18, 2018, there is an
# unreleased version that uses ~> 2.6.  Depending on your existing gems
# you may need to add an explicit dependency on savon-multipart if bundle
# install fails with a mail gem dependency.
#
# You can savon-multipart, or use git diretly with one of the below
#
# savon-multipart as of Jan 18, 2018:
# gem 'savon-multipart', git: "git@github.com:savonrb/savon-multipart.git", ref: 'd9a138b6c166cd7c30c28e8888ff19011f8ec071'
#
# live on the edge
# gem 'savon-multipart', git: "git@github.com:savonrb/savon-multipart.git", branch: :master
#
# Your fork?
# gem 'savon-multipart', git: "git@github.com:YOU/savon-multipart.git"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trizetto-api

## Usage

### Use the Eligibility Web Service with an XML payload to check eligibility in realtime

#### Fields

The Eligibility Web Service is poorly documented in the [Eligibility Web Service Companion Guide](https://mytools.gatewayedi.com/Help/documents/Eligibility/Realtime%20Eligibility%20Webservice%20Companion%20Guide.pdf).

The fields listed below are copied from the documentation and can be used to perform eligibility checks.

|Field| Description | Requirement |
|--|--|--|
| `GediPayerID` | The GEDI specific payer identifier | Always |
| `ProviderFirstName`  | Provider First Name | Required when individual provider name is sent in the inquiry |
| `ProviderLastName`   | Provider Last Name/Organization Name | |
| `NPI`                | National Provider Identifier  | |
| `InsuredFirstName`   | Subscriber First Name | Required when the patient is the subscriber or if the Payer requires this information to identify the patient. |
| `InsuredLastName`    | Subscriber Last Name | Required when the patient is the subscriber or if the Payer requires this information to identify the patient |
| `InsuranceNum`       |  | Required when the payer needs this information to identify patient. |
| `InsuredDob`         | Subscriber Date of birth (YYYYMMDD) | Required when the payer needs this information to identify patient. |
| `InsuredGender`      | Subscriber Gender (M) or (F) | Required when the payer needs this information to identify patient. |
| `ServiceTypeCode`    | Health Care Financing Administration Common Procedural Coding System Code | |
| `DependentFirstName` | Dependent First Name | |
| `DependentLastName`  | Dependent Last Name | |
| `DependentDob`       | Dependent Date of Birth (YYYYMMDD) | |
| `DependentGender`    | Dependent Gender (M) or (F) | |
| `DateOfService`      | Date of service to check for eligibiltiy (YYYYMMDD). **This field is not documented**  | |

#### Example
This uses name/value pairs in a request and returns an XML docunment as a response.

To simply check if the patient is covered by a health plan

```ruby
response = client.do_inquiry({...})
response.active_coverage_for?(service_type_code = "30")  #=> true | false
```

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = ENV['TRIZETTO_USERNAME']
  config.password = ENV['TRIZETTO_PASSWORD']
end

client = Trizetto::Api::Eligibility::WebService::Client.new({
  # You probably don't want logging enable unless you are being very careful to protect PHI in logs
  # pretty_print_xml: true,
  # log: true,
  # log_level: :debug,
})

response = client.do_inquiry({
  'ProviderLastName': 'YOUR_COMPANY_NAME',
  'NPI':              'YOUR NPI HERE',
  'InsuredFirstName': 'Mickey',
  'InsuredLastName':  'Mouse',
  'InsuredDob':       '19281118',
  'GediPayerId':      'N4222',
})



# Were there validation errors with the request?
response.success?                                          # => false
response.success_code                                      # => "ValidationFailure"
response.errors.messages                                   # => ["Please enter InsuranceNum."]
response.errors.validation_failures.first.affected_fields  # => ["InsuranceNum"]
response.errors.validation_failures.first.message          # => "Please enter InsuranceNum."


# Did we successfully get back an eligibility response from the payer.
response.success?                   # => true
response.success_code               # => "Success"
response.transaction_id             # => "c6eb40c5584f0496be3f3a48d0ddfd"
response.trace_number               # => "88213481"
response.payer_name                 # => "BLUE CROSS BLUE SHIELD OF MASSACHUSETTS"
response.active_coverage_for?("30") # => true

# Did the response have group number for the subscriber or dependent?
response.subscriber&.group_number || response.dependent&.group_number  # => "999999999A6AG999"

# What is the subscriber's member number?
response.subscriber.id  # => "XXP123456789"

# Was the response rejected? We got back an eligibility response, but probably the patient wasn't found
response.success?                          # => true
response.success_code                      # => "Success"
response.active_coverage_for?("30")        # => false
response.rejected?                         # => true
response.rejections.count                  # => 1
response.rejections.first.reason           # => "Patient Birth Date Does Not Match That for the Patient on the Database"
response.rejections.first.follow_up_action # => "Please Correct and Resubmit"

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
  config.username = ENV['TRIZETTO_USERNAME']
  config.password = ENV['TRIZETTO_PASSWORD']
end


client = Trizetto::Api::Eligibility::Core2.new
client.check_eligibility(payload: x12_message)
```

### Ping the Payer List endpoint to see if it is up

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = ENV['TRIZETTO_USERNAME']
  config.password = ENV['TRIZETTO_PASSWORD']
end

client = Trizetto::Api::PayerList::WebService.new({
  pretty_print_xml: true,
  log: true,
  log_level: :debug,
})

response = client.ping
```

### Fetch the Payer List

**This API times out or errors out on the Trizetto server**.  But you may get it to work.

```ruby
require 'trizetto/api'

Trizetto::Api.configure do |config|
  config.username = ENV['TRIZETTO_USERNAME']
  config.password = ENV['TRIZETTO_PASSWORD']
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
