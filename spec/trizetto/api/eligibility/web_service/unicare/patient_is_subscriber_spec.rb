RSpec.describe "Unicare - Patient is the subscriber", type: :eligibility_response do
  let(:file) {"unicare/patient_is_subscriber.xml"}

  let(:trace_number) {'999999999'}
  include_examples "active coverage"

  it "additional trace" do
    expect(response.trace_number('THYJHIKSRL')).to eq('99999999999')
  end
end
