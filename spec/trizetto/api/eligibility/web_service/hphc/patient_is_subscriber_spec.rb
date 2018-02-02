RSpec.describe "HPHC - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"hphc/patient_is_subscriber.xml"}

  let(:trace_number) {"99999999"}

  include_examples "active coverage"

  it {expect(response.subscriber).to_not be_nil}
  it {expect(response.dependent).to be_nil}
  it {expect(response.patient).to eq(response.subscriber)}

  context "subscriber" do
    let(:patient) {response.patient}
    let(:name) {patient.name}
    let(:additional_info) {patient.additional_info}

    it {expect(name.first).to eq("MERTIE")}
    it {expect(name.middle).to eq("P")}
    it {expect(name.last).to eq("BOYER")}
    it {expect(name.address).to be_nil}
    it {expect(name.address_2).to be_nil}
    it {expect(name.city).to be_nil}
    it {expect(name.state).to be_nil}
    it {expect(name.zip).to be_nil}

    it {expect(additional_info.length).to eq(1)}
    it {expect(additional_info.first.id).to eq("Plan Network Identification Number")}
    it {expect(additional_info.first.group_policy_number).to eq("99")}
    it {expect(additional_info.first.plan_sponsor_name).to eq("TORPHY INC")}
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it {expect(benefits.count).to eq(73)}
    it {expect(benefits.select(&:active_coverage?).count).to eq(9)}
    it {expect(benefits.select {|c| c.service_type_codes.include?("30")}.count).to eq(6)}


    context "Primary Insurance - PPO Saver" do
      let(:benefit) {benefits[0]}

      it {expect(benefit.info).to eq("Active Coverage")}
      it {expect(benefit).to be_active_coverage}
      it {expect(benefit.coverage_level).to be_nil}
      it {expect(benefit.service_type).to eq("Health Benefit Plan Coverage")}
      it {expect(benefit.service_type_codes).to eq(["30"])}
      it {expect(benefit.insurance_type).to eq("Health Maintenance Organization (HMO)")}
      it {expect(benefit.insurance_type_code).to eq("HM")}
      it {expect(benefit.plan_coverage_description).to eq("ME HMO-Deductible Tiered Copay")}
      it {expect(benefit.date_qualifier).to eq("Eligibility")}
      it {expect(benefit.date_of_service).to eq("20180101-20181231")}
    end

    context "Limitations" do
      let(:matched) {
        benefits.select do |b|
          b.limitation? && b.service_type_codes == ["AL"] && b.time_period_qualifier == "Calendar Year"
        end
      }
      let(:benefit) {matched.first}

      it {expect(matched.count).to eq(1)}
      it {expect(benefit.quantity_qualifier).to eq("Visits")}
      it {expect(benefit.quantity).to eq("1")}
    end

    context "Non Covered" do
      let(:matched) {
        benefits.select do |b|
          b.non_covered? && b.service_type_codes == ["GY"]
        end
      }
      let(:benefit) {matched.first}

      it {expect(matched.count).to eq(1)}
      it {expect(benefit.messages).to eq(["Allergy Injection"])}
    end

    it "Primary Care Provider"  do
      matched = benefits.select(&:primary_care_provider?)
      expect(matched.count).to eq(1)
      benefit = matched.first

      entity = benefit.entity

      {
       entity_code:                    "Primary Care Provider",
       name:                           "JULIUS",
       first:                          "GROLLMAN",
       identification_code_qualifier:  "Health Care Financing Administration National Provider Identifier",
       id:                             "1609858695",
       address_1:                      "4101 TORRANCE BLVD",
       address_2:                      nil,
       city:                           "TORRANCE",
       state:                          "CA",
       zip:                            "90503",
       communication_number_qualifier: "Telephone",
       communication_number:           "3103035750",
      }.each do |field, value|
        actual = entity.public_send(field)
        expect(actual).to eq(value), "Expected #{field} to be #{value} but was #{actual}"
      end
    end

  end
end
