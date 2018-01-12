RSpec.describe "UHC - Rejected", type: :eligibility_response do

  context "Invalid ID" do
    let(:expected_rejections) {
      [
        ["Invalid/Missing Subscriber/Insured Name", "Please Correct and Resubmit"],
        ["Patient Birth Date Does Not Match That for the Patient on the Database", "Please Correct and Resubmit"],
      ]
    }
    let(:file) {"uhc/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Unable to Respond" do
    let(:expected_rejections) {[
      ["Unable to Respond at Current Time", "Resubmission Allowed"]
    ]}

    let(:file) {"uhc/rejection-2.xml"}
    include_examples "rejected"
  end

end
