# This only happened once - the payer site didn't handle the request
# retrying did work.  Perhaps we'll want the client to automatically
# retry these errors, but throw it back as rejected for now.
RSpec.describe "HPHC - Unable to Response", type: :eligibility_response do
  let(:file) {"hphc/unable-to-response-1.xml"}

  let(:expected_rejections) {[
    ["Unable to Respond at Current Time", "Resubmission Allowed"]
  ]}

  include_examples "rejected"
end
