module Trizetto
  module Api
    module Eligibility

      # Ruby Wrapper for the Eligibility Web Service
      #
      # Performs a real time eligibility check using the non-CORE II Web Service
      #
      # The webservice provides 3 eligibility checks:
      #
      # - +DoInquiry+
      # - +DoInquiryByX12Data+
      # - +DoInquiryByX12DataWith271Response+
      #
      # This API, currently, only uses the +DoInquiry+ check.  For X12 requests
      # the CORE II client is recommended instead.
      #
      # See Also:
      #
      # - Service Description: https://services.gatewayedi.com/eligibility/service.asmx
      # - WSDL: https://services.gatewayedi.com/eligibility/service.asmx?WSDL
      # - Realtime Eligibiliy Webservice Companion Guide: https://mytools.gatewayedi.com/Help/documents/Eligibility/Realtime%20Eligibility%20Webservice%20Companion%20Guide.pdf
      # - Realtime Eligibiliy Webservice Vendor Toolkit: https://mytools.gatewayedi.com/Help/documents/Eligibility/Realtime%20Eligibility%20Webservice%20Vendor%20Toolkit.pdf
      # - Eligibility Companion Guide by Payer: https://mytools.gatewayedi.com/help/documents/Eligibility/Payer%20Specific%20Required%20Data%20Elements-2010.pdf
      class WebService < Trizetto::Api::WebService
        def initialize(options={})
          super(options.merge({
            wsdl:        File.join( File.dirname(__FILE__), 'web_service.wsdl' ),
            endpoint:    Trizetto::Api.configuration.eligibiltiy_webservice_endpoint,
          }))
        end

        # Required Field:
        #   +GediPayerId+        - The Gateway EDI specific payer identifier
        #   +ProviderLastName+   - Provider Last Name/Organization Name
        #   +NPI+                - National Provider Identifier
        #
        # Situational Fields:
        #
        #   +ProviderFirstName+  - Provider First Name
        #   +InsuredFirstName+   - Subscriber First Name
        #   +InsuredLastName+    - Subscriber Last Name
        #   +InsuranceNum+       - Subscriber Id
        #   +InsuredDob+         - Subscriber DOB
        #   +InsuredGender+      - Subscriber Gender
        #   +DependentFirstName+ - Dependent First Name
        #   +DependentLastName+  - Dependent Last Name
        #   +DependentDob+       - Dependent DOB
        #   +DependentGender+    - Dependent Gender
        #
        # Note: Some payers require additional information than those listed above. Please refer to the
        # companion guide for the additional parameters required by few payers. A valid inquiry submitted
        # to those payers must also account for the additional payer specific parameters. “InsuranceNum,” in
        # particular, is not a required field for all transactions, but is required by almost all payers.
        #
        # See Also:
        #
        # - Service Description: https://services.gatewayedi.com/eligibility/service.asmx?op=DoInquiry
        def do_inquiry(parameters={})
          @client.call(:do_inquiry, message: { 'Inquiry': {
            'ResponseDataType': 'Xml',
            'Parameters': {
            'MyNameValue': parameters.map do |name, value|
                {'Name': name, 'Value': value}
              end
            }}})
        end

        alias_method :check_eligibility, :do_inquiry
      end
    end
  end
end

