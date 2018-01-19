module EligibilityResponseHelper
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      let(:fixture_path) {
        File.join(RSpec::Core::RubyProject.root, 'spec', 'fixtures', 'files', 'api', 'eligibility', 'web_service')
      }

      let(:response) do
        Trizetto::Api::Eligibility::WebService::DoInquiryResponse.new({
          do_inquiry_response: {
            do_inquiry_result: {
              extra_processing_info: {},
              response_as_xml: File.read(File.join(fixture_path, file))
            }
          }
        })
      end

      let(:trace_number) {'999999999'}
      let(:trace_id) {"99Trizetto"}

      shared_examples_for "not rejected" do
        it do
          expect(response).to_not be_rejected
          expect(response.rejections).to eq([])
        end

        it "trace_number" do
          expect(response.trace_number(trace_id)).to eq(trace_number)
        end

      end

      shared_examples_for "rejected" do
        it do
          expect(response).to be_rejected
          expect(response.rejections.count).to eq(expected_rejections.count)

          expected_rejections.each.with_index do |expected, index|
            raise ArgumentError if expected.length != 2

            expect(response.rejections[index].reason).to eq(expected.first)
            expect(response.rejections[index].follow_up_action).to eq(expected.last)
          end
        end

        it "trace_number" do
          expect(response.trace_number("99Trizetto")).to eq(trace_number)
        end
      end

      shared_examples_for "active coverage" do
        include_examples "not rejected"
        it "has active coverage" do
          expect(response).to be_active_coverage_for("30")
        end
      end

      shared_examples_for "inactive coverage" do
        include_examples "not rejected"
        it "does not have active coverage" do
          expect(response).to_not be_active_coverage_for("30")
        end
      end
    end
  end

  module ClassMethods
  end
end
