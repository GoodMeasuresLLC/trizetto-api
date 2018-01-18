require 'ostruct'

require File.dirname(__FILE__) + "/web_service/rejectable.rb"
require File.dirname(__FILE__) + "/web_service/node.rb"
require File.dirname(__FILE__) + "/web_service/patient.rb"

Dir[File.dirname(__FILE__) + '/web_service/*.rb'].each {|file| require file }

module Trizetto
  module Api
    module Eligibility
      module WebService

        # Raised when the response from Trizetto includes multiple subscribers
        #
        # If raised, please scrub the response for PHI and create an issue in
        # github and include the scrubbed (NO PHI!!) reponse XML.
        class MultipleSubscribersError < StandardError; end

        # Raised when the response from Trizetto includes multiple dependents
        #
        # If raised, please scrub the response for PHI and create an issue in
        # github and include the scrubbed (NO PHI!!) reponse XML.
        class MultipleDependentsError < StandardError; end


        # Ruby Wrapper for the Eligibility Web Service
        #
        # Performs a real time eligibility check using the non-CORE II Web Service
        #
        # The webservice provides 3 eligibility checks:
        #
        # * <tt>DoInquiry</tt>
        # * <tt>DoInquiryByX12Data</tt>
        # * <tt>DoInquiryByX12DataWith271Response</tt>
        #
        # This API, currently, only uses the +DoInquiry+ check.  For X12 requests
        # the CORE II client is recommended instead.
        #
        # <b>Example</b>
        #
        #   client = Trizetto::Api::Eligibility::WebService::Client.new
        #
        #   response = client.do_inquiry({
        #     'ProviderLastName': 'YOUR COMPANY NAME HERE',
        #     'NPI':              'YOUR NPI HERE',
        #     'InsuredFirstName': 'Mickey',
        #     'InsuredLastName':  'Mouse',
        #     'InsuredDob':       '19281118',
        #     'GediPayerId':      'N4222',
        #   })
        #
        # @see DoInquiryResponse
        #
        # *References*
        # * {https://services.gatewayedi.com/eligibility/service.asmx ServiceDescription}
        # * {https://services.gatewayedi.com/eligibility/service.asmx?WSDL WSDL}
        # * {https://mytools.gatewayedi.com/Help/documents/Eligibility/Realtime%20Eligibility%20Webservice%20Companion%20Guide.pdf Realtime Eligibiliy Webservice Companion Guide}
        # * {https://mytools.gatewayedi.com/Help/documents/Eligibility/Realtime%20Eligibility%20Webservice%20Vendor%20Toolkit.pdf Realtime Eligibiliy Webservice Vendor Toolkit}
        # * {https://mytools.gatewayedi.com/help/documents/Eligibility/Payer%20Specific%20Required%20Data%20Elements-2010.pdf Eligibility Companion Guide by Payer}
        class Client < Trizetto::Api::WebService

          def initialize(options={})
            super(
              options.merge(
                {
                  wsdl:        File.join( File.dirname(__FILE__), 'web_service.wsdl' ),
                  endpoint:    Trizetto::Api.configuration.eligibiltiy_webservice_endpoint,
                }
            ))
          end

          # Performs an eligibility check using the trizetto eligibility SOAP API
          #
          # In this request, your company is the Provider, you are providing
          # services to an individual.  For the +ProviderLastName+, you should use
          # you company's name.  For the +NPI+, you should use your company's
          # National Provider Identifier.
          #
          # The +GediPayerId+ is the insurance company.  You want them to pay for the
          # service you have or will provide.  You will need to get these values
          # from Trizetto.
          #
          # Required and optional fields will depend on the Payer being checked.
          # Some payers require additional information than those listed below.
          # Refer to the companion guide for the required additional parameters.
          # A valid inquiry submitted to those payers must also account for the
          # additional payer specific parameters. +InsuranceNum+ in particular,
          # is not a required field for all transactions, but is required by
          # almost all payers.
          #
          # <b>Always Required Fields</b>
          #
          # * <tt>GediPayerId</tt>      - The Gateway EDI specific payer identifier
          # * <tt>ProviderLastName</tt> - Provider Last Name/Organization Name.
          # * <tt>NPI</tt>              - National Provider Identifier
          #
          # <b>Situational Fields</b>
          #
          # * <tt>ProviderFirstName</tt>  - Provider First Name
          # * <tt>InsuredFirstName</tt>   - Subscriber First Name
          # * <tt>InsuredLastName</tt>    - Subscriber Last Name
          # * <tt>InsuranceNum</tt>       - Subscriber Id
          # * <tt>InsuredDob</tt>         - Subscriber DOB
          # * <tt>InsuredGender</tt>      - Subscriber Gender
          # * <tt>DependentFirstName</tt> - Dependent First Name
          # * <tt>DependentLastName</tt>  - Dependent Last Name
          # * <tt>DependentDob</tt>       - Dependent DOB
          # * <tt>DependentGender</tt>    - Dependent Gender
          # * <tt>GroupNumber</tt>        -
          # * <tt>ServiceTypeCode</tt>    - What type of provider service.  30 is Health Plan Benefit Coverage, "General healthcare benefits for the member's policy or contract"
          #
          # <b>References</b>
          # * {https://services.gatewayedi.com/eligibility/service.asmx?op=DoInquiry Service Description}
          # * {http://www.x12.org/codes/health-care-service-type-codes/ Service Type Codes}
          #
          # @return DoInquiryResponse
          def do_inquiry(parameters={})
            DoInquiryResponse.new(
              @client.call( :do_inquiry, message: { 'Inquiry': {
                'ResponseDataType': 'Xml',
                'Parameters': {
                  'MyNameValue': parameters.map { |name, value|
                     {'Name': name, 'Value': value}
                   }
                }
              }})
            )
          end

          alias_method :check_eligibility, :do_inquiry
        end
      end
    end
  end
end
