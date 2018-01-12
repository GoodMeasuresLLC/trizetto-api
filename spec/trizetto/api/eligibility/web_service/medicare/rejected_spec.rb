RSpec.describe "Medicare - Rejected", type: :eligibility_response do

  let(:follow_up_action) {"Please Correct and Resubmit"}

  let(:expected_rejections) {[
    [rejection_reason, follow_up_action]
  ]}

  context "Invalid ID" do
    let(:rejection_reason) {"Invalid/Missing Subscriber/Insured ID"}

    let(:file) {"medicare/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Bad DOB" do
    let(:rejection_reason) {"Patient Birth Date Does Not Match That for the Patient on the Database"}

    let(:file) {"medicare/rejection-2.xml"}
    include_examples "rejected"
  end

end
