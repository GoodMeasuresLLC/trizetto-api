RSpec.describe "UHC - Rejected", type: :eligibility_response do

  context "Invalid ID" do
    let(:expected_rejections) {
      [
        ["Invalid/Missing Subscriber/Insured Name", "Please Correct and Resubmit"],
        ["Patient Birth Date Does Not Match That for the Patient on the Database", "Please Correct and Resubmit"],
      ]
    }

    let(:trace_number) {"1ß2345679"}

    let(:file) {"uhc/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Unable to Respond" do
    let(:expected_rejections) {[
      ["Unable to Respond at Current Time", "Resubmission Allowed"]
    ]}

    let(:trace_number) {"851380932"}
    let(:file) {"uhc/rejection-2.xml"}
    include_examples "rejected"
  end

  context "Invalid Member ID for dependent" do
    let(:expected_rejections) {[
      ["Invalid/Missing Patient ID", "Please Correct and Resubmit"],
      ["Invalid/Missing Patient Name", "Please Correct and Resubmit"],
      ["Patient Birth Date Does Not Match That for the Patient on the Database", "Please Correct and Resubmit"]
    ]}

    # This trace has _two_ numbers, but one _id_ and we don't handle that.  The
    # traces are only included if the count of ids matches the count of numbers
    let(:trace_number) {nil}
    let(:file) {"uhc/rejection-3.xml"}
    include_examples "rejected"
  end
end
