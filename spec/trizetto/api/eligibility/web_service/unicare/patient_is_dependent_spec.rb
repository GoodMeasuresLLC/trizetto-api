RSpec.describe "Unicare - Patient is a dependent", type: :eligibility_response do
  let(:file) {"unicare/patient_is_dependent.xml"}

  let(:trace_id) {'VSUCUMAYCC'}
  let(:trace_number) {'99999999999'}

  include_examples "active coverage"
end
