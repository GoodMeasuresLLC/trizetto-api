RSpec.describe "Mass-Medicade - Provider Not On File", type: :eligibility_response do

  let(:expected_rejections) {[
    ["Provider Not on File", "Please Correct and Resubmit"]
  ]}

  context "massachusetts-medicade/rejection-1.xml" do
    let(:file) {"massachusetts-medicade/rejection-1.xml"}
    include_examples "rejected"
  end

  context "massachusetts-medicade/rejection-2.xml" do
    let(:file) {"massachusetts-medicade/rejection-2.xml"}
    include_examples "rejected"
  end

end
