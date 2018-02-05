RSpec.describe "BMC - Rejected", type: :eligibility_response do

  let(:follow_up_action) {"Please Correct and Resubmit"}

  context "Subscriber Ambiguous" do
    let(:expected_rejections) {[
      ["Duplicate Subscriber/Insured ID Number", follow_up_action],
      ["Invalid/Missing Subscriber/Insured Name", follow_up_action],
      ["Invalid/Missing Date-of-Birth", follow_up_action],
    ]}
      let(:file) {"boston-medical-center/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Subscriber Not Found" do
    let(:expected_rejections) {[
      ["Invalid/Missing Subscriber/Insured ID", follow_up_action],
    ]}
      let(:file) {"boston-medical-center/rejection-2.xml"}
    include_examples "rejected"
  end
end


