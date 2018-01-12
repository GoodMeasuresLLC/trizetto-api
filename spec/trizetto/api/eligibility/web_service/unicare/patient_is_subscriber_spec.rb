RSpec.describe "Unicare - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"unicare/patient_is_subscriber.xml"}

  include_examples "active coverage"
end
