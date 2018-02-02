RSpec.describe "Atenta - Inactive", type: :eligibility_response do
  context "inactive-1" do
    let(:file) {"aetna/inactive-1.xml"}

    let(:trace_number) {"999999999"}
    include_examples "inactive coverage"
  end
end
