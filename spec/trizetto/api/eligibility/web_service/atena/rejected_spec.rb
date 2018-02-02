RSpec.describe "Aetna - Rejected", type: :eligibility_response do

  let(:follow_up_action) {"Please Correct and Resubmit"}

  let(:expected_rejections) {[
    [rejection_reason, follow_up_action]
  ]}

  context "Subscriber Not Found" do
    let(:file) {"aetna/rejection-1.xml"}
    let(:trace_number) {'854939978'}
    let(:rejection_reason) {"Patient Birth Date Does Not Match That for the Patient on the Database"}

    include_examples "rejected"
  end

end


