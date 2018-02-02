RSpec.describe "BCBS - Patient is the subscriber with medicare", type: :eligibility_response do
  let(:file) {"bcbs-ma/patient_is_subscriber_and_has_medicare.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to be_nil}
  it {expect(response.patient).to eq(response.subscriber)}

  context "subscriber" do
    let(:patient) {response.patient}
    let(:name) {patient.name}

    it {expect(name.first).to eq("Derek")}
    it {expect(name.last).to eq("Walter")}
    it {expect(name.middle).to eq("D")}
    it {expect(name.address).to eq("1634 Maverick Glen")}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to eq("Starkbury")}
    it {expect(name.state).to eq("IA")}
    it {expect(name.zip).to eq("38592")}

    it {expect(patient.group_number).to eq('123456789')}
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it {expect(benefits.count).to eq(53)}

    context "Primary Insurance - PPO Saver" do
      let(:benefit) {benefits[0]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.coverage_level).to eq("Family")}
      it {expect(benefit.service_type).to eq("Health Benefit Plan Coverage")}
      it {expect(benefit.service_type_codes).to eq(["30"])}
      it {expect(benefit.insurance_type).to eq("Preferred Provider Organization (PPO)")}
      it {expect(benefit.insurance_type_code).to eq("PR")}
      it {expect(benefit.plan_coverage_description).to eq("PPO - PREFERRED BLUE PPO SAVER")}
    end

    context "Secondary Insurance - Medicare Part A" do
      let(:benefit) {benefits[1]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.coverage_level).to be_nil}
      it {expect(benefit.service_type).to eq("Health Benefit Plan Coverage")}
      it {expect(benefit.service_type_codes).to eq(["30"])}
      it {expect(benefit.insurance_type).to eq("Medicare Part A")}
      it {expect(benefit.insurance_type_code).to eq("MA")}
      it {expect(benefit.messages).to eq(["BCBSMA IS PRIME"])}
      it {expect(benefit.date_qualifier).to eq("Eligibility Begin")}
      it {expect(benefit.date_of_service).to eq("19530124")}
    end

    context "Third benefit" do
      let(:benefit) {benefits[2]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.service_type_codes).to match_array(["1", "33", "35", "88", "AL", "MH", "UC"])}
      it {
        [:coverage_level, :service_type, :insurance_type, :insurance_type_code, :date_qualifier, :date_of_service].each do |field|
          expect(benefit.send(field)).to be_nil, "Expected #{field} to be nil but wasn't"
        end
      }
      it {expect(benefit.messages).to eq([])}
    end

    context "co-insurance for Chiropractic (33), Unknown (50) and Unknown (98)" do
      let(:matching_benefits) {benefits.select {|b| b.co_insurance? && b.service_type_codes.sort == ["33", "50", "98"]}}
      let(:benefit) {matching_benefits.first}

      it {expect(matching_benefits.count).to eq(1)}

      it {expect(benefit.percent).to eq(".2")}
      it {expect(benefit.coverage_level).to eq("Individual")}
      it {expect(benefit.messages).to match_array([
        "AFTER DEDUCTIBLE (AND AMOUNT ABOVE ALLOWED CHARGE)",
        "MEDICAL CARE"
      ])}
      it {expect(benefit.yes_no_response_code).to eq("No")}
      it {expect(benefit.plan_network_indicator).to eq("Out of Plan-Network")}
    end
  end
end
