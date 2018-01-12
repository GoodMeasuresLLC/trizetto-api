RSpec.describe "BCBS - Patient is a dependent", type: :eligibility_response do
  let(:file) {"bcbs-ma/patient_is_dependent.xml"}

  include_examples "active coverage"

  it "has a dependent who is the patient" do
    expect(response.subscriber).to_not be_nil
    expect(response.dependent).to_not be_nil

    expect(response.patient).to eq(response.dependent)

    name = response.patient.name
    expect(name.first).to eq("JUANA")
    expect(name.middle).to eq("M")
    expect(name.last).to eq("ORN")
  end

  it "subscriber" do
    subscriber = response.subscriber
    expect(subscriber.benefits).to eq([])

    name = subscriber.name
    expect(name.first).to eq("NOVA")
    expect(name.last).to eq("ORN")
    expect(name.middle).to be_nil
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it do
      expect(benefits.count).to eq(30)
    end


    it "Primary Insurance - PPO Saver" do
      benefit = benefits[0]

      expect(benefit.info).to eq("Active Coverage")
      expect(benefit).to be_active_coverage
      expect(benefit.coverage_level).to eq("Employee and Spouse")
      expect(benefit.service_type).to eq("Health Benefit Plan Coverage")
      expect(benefit.service_type_codes).to eq(["30"])
      expect(benefit.insurance_type).to eq("Preferred Provider Organization (PPO)")
      expect(benefit.insurance_type_code).to eq("PR")
      expect(benefit.plan_coverage_description).to eq("CDHP")
    end
  end
end
