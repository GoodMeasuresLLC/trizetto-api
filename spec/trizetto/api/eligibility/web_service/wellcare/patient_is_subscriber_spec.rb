RSpec.describe "Wellcare - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"wellcare/patient-is-subscriber-1.xml"}

  let(:trace_number) {'999999999'}
  include_examples "active coverage"

end
