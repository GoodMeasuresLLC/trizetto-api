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

        # See Also:
        #
        # - Service Description: https://services.gatewayedi.com/eligibility/service.asmx?op=DoInquiry
        def do_inquiry(parameters={})
          @client.call(:do_inquiry, message: { 'Inquiry': {'Parameters': {
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

