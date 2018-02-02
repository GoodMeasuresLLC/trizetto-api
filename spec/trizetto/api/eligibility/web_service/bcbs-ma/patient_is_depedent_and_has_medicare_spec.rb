RSpec.describe "BCBS - Patient is a dependent with medicare", type: :eligibility_response do
  let(:file) {"bcbs-ma/patient_is_depedent_and_has_medicare.xml"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to_not be_nil}
  it {expect(response.patient).to eq(response.dependent)}

  context "dependent" do
    let(:dependent) {response.dependent}

    let(:name) { dependent.name}

    it {expect(name.first).to eq("Mercedes")}
    it {expect(name.last).to eq("Brooklyn")}
    it {expect(name.middle).to eq("J")}
    it {expect(name.address).to eq("453 McGlynn Roads")}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to eq("North Nicolas")}
    it {expect(name.state).to eq("WI")}
    it {expect(name.zip).to eq("52378")}
  end

  context "subscriber" do
    let(:subscriber) {response.subscriber}
    let(:name) { subscriber.name}
    let(:additional_info) {subscriber.additional_info}

    it {expect(subscriber.benefits).to eq([])}
    it {expect(subscriber.group_number).to eq("123456789")}
    it {expect(subscriber.plan_number).to be_nil}

    it {expect(additional_info.length).to eq(1)}
    it {expect(additional_info.last.id).to eq("Group Number") }

    it {expect(name.first).to eq("Rocky")}
    it {expect(name.middle).to eq("D")}
    it {expect(name.last).to eq("Brooklyn")}
    it {expect(name.address).to eq("5105 DAISHA MOUNTAINS")}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to eq("SOUTH MOSESPORT")}
    it {expect(name.state).to eq("NE")}
    it {expect(name.zip).to eq("30683")}
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it do
      expect(benefits.count).to eq(53)
    end

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
      it {expect(benefit.date_of_service).to eq("19641217")}
    end

    context "Third benefit" do
      let(:benefit) {benefits[2]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.service_type_codes).to match_array(["1", "33", "35", "88", "AL", "MH", "UC"])}

      it do
        [:coverage_level, :service_type, :insurance_type, :insurance_type_code, :date_qualifier, :date_of_service].each do |field|
          expect(benefit.send(field)).to be_nil, "Expected #{field} to be nil but wasn't"
        end
      end

      it {expect(benefit.messages).to eq([])}
    end

    context "co-insurance for Chiropractic (33), Unknown (50) and Unknown (98)" do
      let(:matched_benefits) {
        benefits.select {|b| b.co_insurance? && b.service_type_codes.sort == ["33", "50", "98"]}
      }
      let(:benefit) {matched_benefits.first}

      it {expect(matched_benefits.count).to eq(1)}


      it {expect(benefit.percent).to eq(".2")}
      it {expect(benefit.coverage_level).to eq("Individual")}
      it {
          expect(benefit.messages).to match_array([
          "AFTER DEDUCTIBLE (AND AMOUNT ABOVE ALLOWED CHARGE)",
          "MEDICAL CARE"
        ])
      }
      it {expect(benefit.yes_no_response_code).to eq("No")}
      it {expect(benefit.plan_network_indicator).to eq("Out of Plan-Network")}
    end
  end
end
