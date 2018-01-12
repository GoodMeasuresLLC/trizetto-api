module Trizetto
  module Api
    module Eligibility
      module WebService

        # Validation failures from the DoInquiryRequest.
        #
        # <b>WSDL Reference</b>
        #
        #   <s:element minOccurs="0" maxOccurs="1" name="ExtraProcessingInfo" type="tns:ValidationFailureCollection" />
        #
        class ExtraProcessingInfo

          # An array of strings, each a single validation failure
          attr_accessor :messages

          # An array of ValidationFailure, each indicating field that had errors
          attr_accessor :validation_failures

          def initialize(extra_processing_info)
            self.messages = Array(extra_processing_info.dig(:all_messages, :string))

            failures = extra_processing_info.dig(:failures,:validation_failure) || []
            failures = [failures] if failures.is_a?(Hash)

            self.validation_failures = failures.map do |failure|
              ValidationFailure.new(failure)
            end
          end

          def to_h
            {
              messages: messages,
              validation_failures: validation_failures.map(&:to_h)
            }
          end
        end
      end
    end
  end
end
