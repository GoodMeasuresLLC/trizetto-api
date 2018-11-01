RSpec.describe "BCBS - Rejected", type: :eligibility_response do

  let(:follow_up_action) {"Please Correct and Resubmit"}

  let(:expected_rejections) {[
    [rejection_reason, follow_up_action]
  ]}

  context "Subscriber Not Found" do
    let(:file) {"bcbs-ma/rejection-1.xml"}

    let(:rejection_reason) {"Subscriber/Insured Not Found"}

    include_examples "rejected"
  end

  context "Invalid ID" do
    let(:file) {"bcbs-ma/rejection-2.xml"}

    let(:rejection_reason) {"Invalid/Missing Subscriber/Insured ID"}

    include_examples "rejected"
  end

  context "Invalid NPI" do
    let(:file) {"bcbs-ma/rejection-invalid-npi.xml"}

    let(:rejection_reason) {"Invalid/Missing Referring Provider Identification Number"}

    include_examples "rejected"
  end
end


