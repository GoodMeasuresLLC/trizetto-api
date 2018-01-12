RSpec.describe "BCBS - Patient is the subscriber with medicare", type: :eligibility_response do
  let(:file) {"bcbs-ma/patient_is_subscriber_and_has_medicare.xml"}

  include_examples "active coverage"

  it "has a subscriber who is the patient" do
    expect(response.subscriber).to_not be_nil
    expect(response.dependent).to be_nil

    expect(response.patient).to eq(response.subscriber)

    name = response.patient.name
    expect(name.first).to eq("Derek")
    expect(name.last).to eq("Walter")
    expect(name.middle).to eq("D")
    expect(name.address).to eq("1634 Maverick Glen")
    expect(name.address_2).to be_nil
    expect(name.city).to eq("Starkbury")
    expect(name.state).to eq("IA")
    expect(name.zip).to eq("38592")
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it do
      expect(benefits.count).to eq(53)
    end

    it "Primary Insurance - PPO Saver" do
      benefit = benefits[0]

      expect(benefit.info).to eq("Active Coverage")
      expect(benefit).to be_active_coverage
      expect(benefit.coverage_level).to eq("Family")
      expect(benefit.service_type).to eq("Health Benefit Plan Coverage")
      expect(benefit.service_type_codes).to eq(["30"])
      expect(benefit.insurance_type).to eq("Preferred Provider Organization (PPO)")
      expect(benefit.insurance_type_code).to eq("PR")
      expect(benefit.plan_coverage_description).to eq("PPO - PREFERRED BLUE PPO SAVER")
    end

    it "Secondary Insurance - Medicare Part A" do
      benefit = benefits[1]

      expect(benefit.info).to eq("Active Coverage")
      expect(benefit).to be_active_coverage
      expect(benefit.coverage_level).to be_nil
      expect(benefit.service_type).to eq("Health Benefit Plan Coverage")
      expect(benefit.service_type_codes).to eq(["30"])
      expect(benefit.insurance_type).to eq("Medicare Part A")
      expect(benefit.insurance_type_code).to eq("MA")
      expect(benefit.messages).to eq(["BCBSMA IS PRIME"])
      expect(benefit.date_qualifier).to eq("Eligibility Begin")
      expect(benefit.date_of_service).to eq("19530124")
    end

    it "Third benefit" do
      benefit = benefits[2]
      expect(benefit.info).to eq("Active Coverage")
      expect(benefit).to be_active_coverage
      expect(benefit.service_type_codes).to match_array(["1", "33", "35", "88", "AL", "MH", "UC"])
      [:coverage_level, :service_type, :insurance_type, :insurance_type_code, :date_qualifier, :date_of_service].each do |field|
        expect(benefit.send(field)).to be_nil, "Expected #{field} to be nil but wasn't"
      end
      expect(benefit.messages).to eq([])
    end

    it "co-insurance for Chiropractic (33), Unknown (50) and Unknown (98)" do
      benefit = benefits.select {|b| b.co_insurance? && b.service_type_codes.sort == ["33", "50", "98"]}
      expect(benefit.count).to eq(1)
      benefit = benefit.first

      expect(benefit.percent).to eq(".2")
      expect(benefit.coverage_level).to eq("Individual")
      expect(benefit.messages).to match_array([
        "AFTER DEDUCTIBLE (AND AMOUNT ABOVE ALLOWED CHARGE)",
        "MEDICAL CARE"
      ])
      expect(benefit.yes_no_response_code).to eq("No")
      expect(benefit.plan_network_indicator).to eq("Out of Plan-Network")
    end
  end
end
