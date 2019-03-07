RSpec.describe "Wellcare - Inactive", type: :eligibility_response do

  context "inactive-1" do
    let(:file) {"wellcare/inactive-1.xml"}

    let(:trace_number) {"9999999999"}
    include_examples "inactive coverage"
  end

end
