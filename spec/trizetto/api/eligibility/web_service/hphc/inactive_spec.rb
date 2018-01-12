RSpec.describe "HPHC - Inactive", type: :eligibility_response do
  let(:file) {"hphc/inactive-1.xml"}

  include_examples "inactive coverage"

  it "has a subscriber" do
    expect(response.subscriber).to_not be_nil
    expect(response.dependent).to be_nil

    patient = response.patient
    expect(patient).to eq(response.subscriber)

    name = patient.name
    expect(name.first).to eq("DEONTE")
    expect(name.last).to eq("BAUCH")


    expect(patient.id).to eq("HP999999999")
    expect(patient.sex).to eq("Female")
    expect(patient.date_of_birth).to eq("19570109")
  end

  it "benefits" do
    benefits = response.patient.benefits
    expect(benefits.count).to eq(1)

    benefit = benefits.first
    expect(benefit.info).to eq("Inactive")
    expect(benefit.service_type_codes).to eq(["30"])
    expect(benefit).to be_inactive
    expect(benefit.date_qualifier).to eq("Eligibility")
    expect(benefit.date_of_service).to eq("20170101-20170415")
  end
end
