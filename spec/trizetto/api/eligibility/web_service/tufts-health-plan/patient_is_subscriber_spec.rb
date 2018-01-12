RSpec.describe "Tufts - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"tufts-health-plan/patient_is_subscriber.xml"}

  include_examples "active coverage"
end
