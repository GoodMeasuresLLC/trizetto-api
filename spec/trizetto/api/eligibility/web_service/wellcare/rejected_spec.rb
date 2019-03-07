RSpec.describe "Wellcare - Rejected", type: :eligibility_response do

  context "Invalid ID" do
    let(:expected_rejections) {
      [
        ["Subscriber/Insured Not Found", "Please Correct and Resubmit"],
      ]
    }

    let(:trace_number) {"999999999"}

    let(:file) {"wellcare/rejection-1.xml"}
    include_examples "rejected"
  end

  context "Unable to Response" do
    let(:file) {"wellcare/rejection-2.xml"}

    let(:expected_rejections) {[
      ["Unable to Respond at Current Time", "Resubmission Allowed"]
    ]}

    include_examples "rejected"
  end


end
