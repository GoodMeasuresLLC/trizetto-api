# Parses raw soap responses
RSpec.describe Trizetto::Api::Eligibility::WebService do
  let(:fixture_path) {
    File.join(RSpec::Core::RubyProject.root, 'spec', 'fixtures', 'files', 'api', 'eligibility', 'web_service')
  }
  # Parse the response file into a DoInquiryResponse.
  def inquiry_response(file)
    parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
    fixture_as_hash = parser.parse(File.read(File.join(fixture_path, file))).dig(:"soap:envelope", :"soap:body")
    Trizetto::Api::Eligibility::WebService::DoInquiryResponse.new(fixture_as_hash)
  end

  # We don't always succeed in our request - sometimes fields are required by
  # the payer that we didn't provide, the payer system is unable to response,
  # we provide invalid data and so on.  In these cases, we don't get an XML
  # response - instead we get back errors at a higher level   These are basic
  # parse tests and I expect the response object to evolve as it gets used to
  # build a user interface
  context "Soap Responses" do
    let(:validation_failures) {
      [
        "soap-responses/validation-failure-1.xml",
        "soap-responses/validation-failure-2.xml",
        "soap-responses/validation-failure-3.xml",
        "soap-responses/validation-failure-4.xml",
        "soap-responses/validation-failure-5.xml",
        "soap-responses/validation-failure-6.xml",
        "soap-responses/validation-failure-7.xml",
        "soap-responses/validation-failure-8.xml",
        "soap-responses/validation-failure-9.xml",
        "soap-responses/validation-failure-10.xml",
      ]
    }

    let(:system_errors) {
      [
        # I don't remeber what happened here - maybe no provider last name.  Whatever
        # happened, Trizetto / the provider gave very little information about what
        # went wrong
        "soap-responses/system-error-1.xml",

        # I submitted this with way too little information.  Thats a system error apparently
        "soap-responses/system-error-2.xml",
      ]
    }

    let(:successes) {
      [
        "soap-responses/success-1.xml",
      ]
    }

    let(:transmission_errors) {
      [
        "soap-responses/transmission-error-1.xml",
      ]
    }

    let(:other_errors) {
      [
        "soap-responses/invalid-gender-response-1.xml",
      ]
    }

    let(:payer_not_supported) {
      [
        "soap-responses/payer-not-supported-1.xml",
      ]
    }

    let(:all_tests) {
      validation_failures + system_errors + successes + transmission_errors + other_errors + payer_not_supported
    }

    # These make sure all the XML capture parses at least
    context "parsing tests" do

      it "all soap don't have active coverage" do
        all_tests.shuffle.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_active_coverage_for("30"), "Expected #{file} to not have active coverage for service type code 30"
        end
      end
      it "successes" do
        successes.each do |file|
          response = inquiry_response(file)
          expect(response).to be_success
        end
      end

      it "validation-failures" do
        validation_failures.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_success
          expect(response.success_code).to eq('ValidationFailure')
          expect(response.transaction_id).to be_blank
          expect(response.payer_id).to be_blank
          expect(response.payer_name).to be_blank
        end
      end

      it "system_errors" do
        system_errors.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_success
          expect(response.success_code).to eq('SystemError')
          expect(response.transaction_id).to be_blank
          expect(response.payer_id).to be_blank
          expect(response.payer_name).to be_blank

          expect(response.extra_processing_info.messages).to match_array([])
          expect(response.extra_processing_info.validation_failures).to match_array([])
          expect(response.extra_processing_info.to_h).to eq({
            messages: [], validation_failures: []
          })
        end
      end

      it "other errors" do
        other_errors.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_success
          expect(response.success_code).to eq("Success")
        end
      end

      it "payer not supported" do
        payer_not_supported.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_success
        end
      end

      it "transmission_errors" do
        transmission_errors.each do |file|
          response = inquiry_response(file)
          expect(response).to_not be_success
          expect(response.success_code).to eq("Success")
        end
      end
    end

    context "soap-responses/success-1.xml" do
      let(:file) {"soap-responses/success-1.xml"}
      let(:response) {inquiry_response(file)}

      it do
        expect(response).to be_success
        expect(response.success_code).to eq('Success')
        expect(response.transaction_id).to eq('aa9ff6d9f74ff89e736b9e7c252739')
        expect(response.payer_id).to eq('10285')
        expect(response.payer_name).to eq('UNICARE')
      end
    end

    # A basic failure - one field with errors
    context "soap-responses/validation-failure-1.xml" do
      let(:file) {"soap-responses/validation-failure-1.xml"}
      let(:response) {inquiry_response(file)}

      it do
        expect(response.extra_processing_info.messages).to match_array(['Invalid InsuredFirstName Length.'])
        expect(response.extra_processing_info.to_h).to eq({
           messages:  ["Invalid InsuredFirstName Length."],
           validation_failures: [
              {
                affected_fields: ["InsuredFirstName"],
                message: "Invalid InsuredFirstName Length."
              }
            ]}
        )

        expect(response.extra_processing_info.validation_failures.length).to eq(1)
        expect(response.extra_processing_info.validation_failures[0].affected_fields).to eq(['InsuredFirstName'])
        expect(response.extra_processing_info.validation_failures[0].message).to eq('Invalid InsuredFirstName Length.')
      end
    end

    # This has multiple fields with errors
    context "soap-responses/validation-failure-2.xml" do
      let(:file) {"soap-responses/validation-failure-2.xml"}
      let(:response) {inquiry_response(file)}

      it do
        expect(response.extra_processing_info.messages).to match_array(['Please enter InsuranceNum.', 'Please enter InsuredFirstName.'])
        expect(response.extra_processing_info.to_h).to eq({
           messages: ['Please enter InsuranceNum.', 'Please enter InsuredFirstName.'],
           validation_failures: [
              {
                affected_fields: ["InsuranceNum"],
                message: "Please enter InsuranceNum."
              },
              {
                affected_fields: ["InsuredFirstName"],
                message: "Please enter InsuredFirstName."
              },
            ]}
          )
      end
    end

    # This one doens't have affected_fields in the validation failures
    context "soap-responses/validation-failure-5.xml" do
      let(:file) {"soap-responses/validation-failure-5.xml"}
      let(:response) {inquiry_response(file)}

      it do
        expect(response.extra_processing_info.messages).to match_array(['Name Value Parameters can not be empty'])
        expect(response.extra_processing_info.to_h).to eq({
           messages: ['Name Value Parameters can not be empty'],
           validation_failures: [
              {
                affected_fields: [],
                message: "Name Value Parameters can not be empty"
              },
            ]}
          )
      end
    end




    context "soap-responses/system-error-1.xml" do
      let(:file) {"soap-responses/system-error-1.xml"}
      let(:response) {inquiry_response(file)}

    end


    context "soap-responses/system-error-2.xml" do
      let(:file) {"soap-responses/system-error-2.xml"}
      let(:response) {inquiry_response(file)}

      it do
        expect(response.extra_processing_info.messages).to match_array([])
        expect(response.extra_processing_info.validation_failures).to match_array([])
        expect(response.extra_processing_info.to_h).to eq({
          messages: [], validation_failures: []
        })
      end
    end
  end
end
