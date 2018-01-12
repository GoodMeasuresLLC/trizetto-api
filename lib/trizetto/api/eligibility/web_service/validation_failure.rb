module Trizetto
  module Api
    module Eligibility
      module WebService
        # Wraps a validation error returned in the SOAP response body
        #
        # <b>Example</b>
        #
        #   failure = ValidationFailure.new({affected_fields: {string: "InsuranceNum"}, message: "Please enter InsuranceNum."}`)
        #   failure.affected_fields   # =>["InsuranceNum"]
        #   failure.message           # => "Please enter InsuranceNum."
        #
        class ValidationFailure

          # An array of strings indicating which fields had a validation failure.
          #
          # While the WSDL has this as an array, in practice, there is one field in that array
          #
          # <b>WSDL Reference</b>
          #
          #   <s:element minOccurs="0" maxOccurs="1" name="AffectedFields" type="tns:ArrayOfString" />
          #
          attr_accessor :affected_fields

          # The validation error associated with the affected fields
          #
          # <b>WSDL Reference</b>
          #
          #   <s:element minOccurs="0" maxOccurs="1" name="Message" type="s:string" />
          #
          attr_accessor :message

          # Initialize the Validation failure from a parsed DoInquiry response hash
          #
          def initialize(validation_failure_hash)
            self.affected_fields = Array((validation_failure_hash.dig(:affected_fields) || {})[:string])
            self.message         = validation_failure_hash[:message]
          end

          def to_h
            {affected_fields: affected_fields, message: message}
          end
        end
      end
    end
  end
end
