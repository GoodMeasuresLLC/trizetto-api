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


  context "Invalid NPI" do
    let(:file) {"aetna/rejection-invalid-npi-1.xml"}
    let(:rejection_reason) {"Invalid/Missing Provider Identification"}

    include_examples "rejected"
  end

  context "Invalid NPI" do
    let(:file) {"aetna/rejection-invalid-npi-2.xml"}
    let(:rejection_reason) {"Invalid/Missing Provider Identification"}
    let(:trace_number) {'1319724445'}

    include_examples "rejected"
  end

end


