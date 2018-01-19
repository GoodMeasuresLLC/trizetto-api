RSpec.describe "UHC - Inactive", type: :eligibility_response do

  # one of these was Minnie Mouse, the other was Micky Mouse

  context "inactive-1" do
    let(:file) {"uhc/inactive-1.xml"}

    let(:trace_number) {"851378049"}
    include_examples "inactive coverage"
  end

  context "inactive-2" do
    let(:file) {"uhc/inactive-2.xml"}

    let(:trace_number) {"851507962"}
    include_examples "inactive coverage"
  end

end
