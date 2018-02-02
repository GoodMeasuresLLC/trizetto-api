RSpec.describe "Tufts - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"tufts-health-plan/patient_is_subscriber.xml"}

  let(:trace_number) {"99999999"}
  include_examples "active coverage"

  let(:patient) {response.patient}

  it {expect(patient.id).to eq("N0199999999")}
end
