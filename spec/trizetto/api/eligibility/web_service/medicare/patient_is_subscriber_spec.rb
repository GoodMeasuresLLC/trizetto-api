RSpec.describe "Medicare - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"medicare/patient_is_subscriber.xml"}

  include_examples "active coverage"

  let(:patient) {response.patient}

  it {expect(patient.id).to eq('999999999A')}
end
