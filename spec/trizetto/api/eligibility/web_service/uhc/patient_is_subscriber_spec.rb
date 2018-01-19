RSpec.describe "UHC - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"uhc/patient_is_subscriber.xml"}

  let(:trace_number) {"851370272"}
  include_examples "active coverage"
end
