RSpec.describe "Unicare - Patient is a dependent", type: :eligibility_response do
  let(:file) {"unicare/patient_is_dependent.xml"}

  include_examples "active coverage"
end
