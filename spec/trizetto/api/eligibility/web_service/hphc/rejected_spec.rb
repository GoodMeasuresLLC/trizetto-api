RSpec.describe "HPHC - Rejected", type: :eligibility_response do
  let(:trace_number) {"99999999"}

  # This only happened once - the payer site didn't handle the request
  # retrying did work.  Perhaps we'll want the client to automatically
  # retry these errors, but throw it back as rejected for now.
  context "Unable to Response" do
    let(:file) {"hphc/unable-to-response-1.xml"}

    let(:expected_rejections) {[
      ["Unable to Respond at Current Time", "Resubmission Allowed"]
    ]}

    include_examples "rejected"
  end

  context "Invalid NPI" do
    let(:file) {"hphc/rejection-invalid-npi.xml"}
    let(:expected_rejections) {[
      ["Invalid/Missing Provider Identification", "Please Correct and Resubmit"]
    ]}
    include_examples "rejected"
  end

  context "Subscriber Not Found" do
    let(:expected_rejections) {[
      ["Invalid/Missing Subscriber/Insured Name", "Please Correct and Resubmit"],
    ]}
    let(:file) {"hphc/rejection-1.xml"}
    include_examples "rejected"
  end

end
