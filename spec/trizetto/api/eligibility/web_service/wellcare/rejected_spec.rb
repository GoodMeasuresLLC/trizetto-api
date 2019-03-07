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
end
