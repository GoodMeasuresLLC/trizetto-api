RSpec.describe "HPHC - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"hphc/patient_is_subscriber.xml"}

  include_examples "active coverage"

  it "has a subscriber who is the patient" do
    expect(response.subscriber).to_not be_nil
    expect(response.dependent).to be_nil

    expect(response.patient).to eq(response.subscriber)

    name = response.patient.name
    expect(name.first).to eq("MERTIE")
    expect(name.middle).to eq("P")
    expect(name.last).to eq("BOYER")
    expect(name.address).to be_nil
    expect(name.address_2).to be_nil
    expect(name.city).to be_nil
    expect(name.state).to be_nil
    expect(name.zip).to be_nil
  end

  context "benefits" do
    let(:benefits) {
      response.patient.benefits
    }

    it do
      expect(benefits.count).to eq(73)
      expect(benefits.select(&:active_coverage?).count).to eq(9)
      expect(benefits.select {|c| c.service_type_codes.include?("30")}.count).to eq(6)
    end


    it "Primary Insurance - PPO Saver" do
      benefit = benefits[0]

      expect(benefit.info).to eq("Active Coverage")
      expect(benefit).to be_active_coverage
      expect(benefit.coverage_level).to be_nil
      expect(benefit.service_type).to eq("Health Benefit Plan Coverage")
      expect(benefit.service_type_codes).to eq(["30"])
      expect(benefit.insurance_type).to eq("Health Maintenance Organization (HMO)")
      expect(benefit.insurance_type_code).to eq("HM")
      expect(benefit.plan_coverage_description).to eq("ME HMO-Deductible Tiered Copay")
      expect(benefit.date_qualifier).to eq("Eligibility")
      expect(benefit.date_of_service).to eq("20180101-20181231")
    end

    it "Limitations" do
      matched = benefits.select do |b|
        b.limitation? && b.service_type_codes == ["AL"] && b.time_period_qualifier == "Calendar Year"
      end

      expect(matched.count).to eq(1)
      benefit = matched.first

      expect(benefit.quantity_qualifier).to eq("Visits")
      expect(benefit.quantity).to eq("1")
    end

    it "Non Covered" do
      matched = benefits.select do |b|
        b.non_covered? && b.service_type_codes == ["GY"]
      end

      expect(matched.count).to eq(1)
      benefit = matched.first

      expect(benefit.messages).to eq(["Allergy Injection"])
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
