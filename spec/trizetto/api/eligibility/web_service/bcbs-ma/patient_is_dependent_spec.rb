RSpec.describe "BCBS - Patient is a dependent", type: :eligibility_response do
  let(:file) {"bcbs-ma/patient_is_dependent.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to_not be_nil}
  it {expect(response.patient).to eq(response.dependent)}

  context "dependent" do
    let(:dependent) {response.dependent}
    let(:additional_info) {dependent.additional_info}
    let(:name) {dependent.name}

    it {expect(additional_info.length).to eq(2)}
    it {expect(additional_info.last.id).to eq("6P") }

    it {expect(dependent.group_number).to eq("999999999A6AG999")}

    it {expect(name.first).to eq("JUANA")}
    it {expect(name.middle).to eq("M")}
    it {expect(name.last).to eq("ORN")}
  end

  context "subscriber" do
    let(:subscriber) {response.subscriber}
    let(:name) {subscriber.name}

    it {expect(subscriber.benefits).to eq([])}

    it {expect(name.first).to eq("NOVA")}
    it {expect(name.last).to eq("ORN")}
    it {expect(name.middle).to be_nil}
  end


  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it do
      expect(benefits.count).to eq(30)
    end

    context "Primary Insurance - PPO Saver" do
      let(:benefit) {benefits[0]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.coverage_level).to eq("Employee and Spouse")}
      it {expect(benefit.service_type).to eq("Health Benefit Plan Coverage")}
      it {expect(benefit.service_type_codes).to eq(["30"])}
      it {expect(benefit.insurance_type).to eq("Preferred Provider Organization (PPO)")}
      it {expect(benefit.insurance_type_code).to eq("PR")}
      it {expect(benefit.plan_coverage_description).to eq("CDHP")}
    end
  end
end
