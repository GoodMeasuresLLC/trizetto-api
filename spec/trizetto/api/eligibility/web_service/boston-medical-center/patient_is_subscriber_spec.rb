RSpec.describe "BMC - Patient is the subscriber (1)", type: :eligibility_response do
  let(:file) {"boston-medical-center/patient-is-subscriber-1.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to be_nil}
  it {expect(response.patient).to eq(response.subscriber)}

  context "subscriber" do
    let(:patient) {response.patient}
    let(:name) {patient.name}

    it {expect(patient.id).to eq("C00094050") }

    it {expect(name.first).to eq("Amelie")}
    it {expect(name.middle).to eq("P")}
    it {expect(name.last).to eq("Hickle")}
    it {expect(name.address).to eq("5041 Marina Squares")}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to eq("Satterfieldport")}
    it {expect(name.state).to eq("MA")}
    it {expect(name.zip).to eq("56754")}

    it {expect(patient.group_number).to eq("G0000000")}
  end
end


RSpec.describe "BMC - Patient is the subscriber (2)", type: :eligibility_response do
  let(:file) {"boston-medical-center/patient-is-subscriber-2.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to be_nil}
  it {expect(response.patient).to eq(response.subscriber)}

  context "subscriber" do
    let(:patient) {response.patient}
    let(:name) {patient.name}

    it {expect(patient.id).to eq("C00029549") }

    it {expect(name.first).to eq("Jaiden")}
    it {expect(name.middle).to eq("S")}
    it {expect(name.last).to eq("Harris")}
    it {expect(name.address).to eq("916 Mozell Station")}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to eq("Strosinton")}
    it {expect(name.state).to eq("WY")}
    it {expect(name.zip).to eq("40149")}

    it {expect(patient.group_number).to eq("G0000000")}
  end

end
