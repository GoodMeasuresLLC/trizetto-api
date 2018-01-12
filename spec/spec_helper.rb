require "bundler/setup"
require "trizetto/api"

require "byebug"

Dir[File.join(RSpec::Core::RubyProject.root, "spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.include EligibilityResponseHelper, type: :eligibility_response

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
