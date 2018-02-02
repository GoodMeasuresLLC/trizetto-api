RSpec.describe "Aetna - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"aetna/patient_is_subscriber.xml"}

  let(:trace_number) {"999999999"}

  include_examples "active coverage"

  context "subscriber" do
    let(:patient) {response.patient}
    let(:additional_info) {patient.additional_info}
    let(:name) {patient.name}

    it {expect(patient).to eq(response.subscriber)}
    it {expect(response.dependent).to be_nil}

    it {expect(name.first).to eq("CARLIE")}
    it {expect(name.last).to eq("JASKOLSKI")}
    it {expect(name.address).to eq("632 MANTE DRIVES")}
    it {expect(name.address_2).to eq("APT 2X")}
    it {expect(name.city).to eq("SOUTH MURPHY")}
    it {expect(name.state).to eq("WI")}
    it {expect(name.zip).to eq("38852")}

    it {expect(patient.id).to eq('W999999999')}
    it {expect(patient.date_of_birth).to eq('19830107')}
    it {expect(patient.sex).to eq("Female")}

    it {expect(patient.group_number).to eq("999999999999999")}
    it {expect(patient.plan_number).to eq("AAAAAAA")}

    it {expect(additional_info.length).to eq(2)}
    it {expect(additional_info.first.id).to eq("Plan Number") }
    it {expect(additional_info.last.id).to eq("Group Number") }
  end

end
