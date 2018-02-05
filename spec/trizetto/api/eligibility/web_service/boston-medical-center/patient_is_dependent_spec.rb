RSpec.describe "BMC - Patient is a dependent", type: :eligibility_response do
  let(:file) {"boston-medical-center/patient-is-dependent-1.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to_not be_nil}
  it {expect(response.patient).to eq(response.dependent)}

  context "dependent" do
    let(:dependent) {response.dependent}
    let(:name) {dependent.name}

    it {expect(dependent.group_number).to eq("G0000000")}
    it {expect(dependent.date_of_birth).to eq("19390806")}

    it {expect(name.first).to eq("Albert")}
    it {expect(name.middle).to eq("H")}
    it {expect(name.last).to eq("Leuschke")}

    it {expect(name.address).to eq("91734 Karina Mountain")}
    it {expect(name.address_2).to eq("APT 6F")}
    it {expect(name.city).to eq("Teresafort")}
    it {expect(name.state).to eq("OH")}
    it {expect(name.zip).to eq("76458")}

    it {expect(dependent.benefits.count).to eq(14)}
  end

  context "subscriber" do
    let(:subscriber) {response.subscriber}
    let(:name) {subscriber.name}

    it {expect(subscriber.benefits).to eq([])}
    it {expect(subscriber.group_number).to eq("G0000000")}
    it {expect(subscriber.id).to eq("C00064190")}

    it {expect(name.first).to eq("Emmanuelle")}
    it {expect(name.last).to eq("Leuschke")}
    it {expect(name.middle).to be_nil}
  end
end
