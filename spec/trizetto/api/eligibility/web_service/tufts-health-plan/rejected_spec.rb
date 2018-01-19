RSpec.describe "Tufts - Rejected", type: :eligibility_response do

  context "Invalid ID" do
    let(:expected_rejections) {
      [
        ["Patient Birth Date Does Not Match That for the Patient on the Database", "Please Correct and Resubmit"]
      ]
    }

    let(:trace_number) {"999999999"}

    let(:file) {"tufts-health-plan/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Missing ID" do
    let(:expected_rejections) {[
      ["Invalid/Missing Subscriber/Insured ID", "Please Correct and Resubmit"]
    ]}

    let(:trace_number) {"999999999"}
    let(:file) {"tufts-health-plan/rejection-2.xml"}
    include_examples "rejected"
  end

end
