RSpec.describe "Medicare - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"medicare/patient_is_subscriber.xml"}

  include_examples "active coverage"
end
