RSpec.describe "Tufts - Inactive", type: :eligibility_response do
  let(:file) {"tufts-health-plan/inactive-1.xml"}

  include_examples "inactive coverage"
end
