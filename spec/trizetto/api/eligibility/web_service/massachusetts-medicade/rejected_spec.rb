RSpec.describe "Mass-Medicade - Provider Not On File", type: :eligibility_response do

  let(:expected_rejections) {[
    ["Provider Not on File", "Please Correct and Resubmit"]
  ]}


  context "massachusetts-medicade/rejection-1.xml" do
    let(:file) {"massachusetts-medicade/rejection-1.xml"}
    let(:trace_number) {"99999999"}
    include_examples "rejected"
  end

  context "massachusetts-medicade/rejection-2.xml" do
    let(:file) {"massachusetts-medicade/rejection-2.xml"}
    let(:trace_number) {"99999999"}
    include_examples "rejected"
  end

end
