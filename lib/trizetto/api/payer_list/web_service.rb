module Trizetto
  module Api
    module PayerList

      # Ruby wrapper for the PayerList WebService
      #
      # <b>References</b>
      #
      # - {https://mytools.gatewayedi.com/Help/documents/Eligibility/WS%20PayerList%20Vendor%20Toolkit.pdf Service Documentation}
      # - {https://services.gatewayedi.com/PayerList/PayerList.asmx?WSDL WSDL}
      # - {https://services.gatewayedi.com/PayerList/PayerList.asmx Service Description}
      class WebService < Trizetto::Api::WebService

        def initialize(options = {})
          super(options.merge({
            wsdl:        File.join( File.dirname(__FILE__), 'web_service.wsdl' ),
            endpoint:    Trizetto::Api.configuration.payer_list_webservice_endpoint,
          }))
        end

        # Tests to see if the service is up
        #
        # <b>References</b>
        # - {https://services.gatewayedi.com/PayerList/PayerList.asmx?op=Ping Service Description }
        def ping
          @client.call(:ping, message: {})
        end

        # Retrieves all Gateway EDI recognized payers along with their supported transaction types and
        # servicing states and links to their enrollment documentation, if it exists.
        #
        # The service provides the following information for each payer
        # - Type – HCFA or UB.
        # - Payer ID – The Gateway EDI payer identification number.
        # - Payer Name – The payer name.
        # - Nation Wide – Yes or No.
        # - Servicing States – List of supported states.
        # - Supported Transactions – List of supported transactions.
        # -- Description – A description of the available transactions. Transaction include Claims, Real-time Claim Status, Remittance Advice, Real-time Eligibility, and Electronic COB.
        # -- Enrollment Required – Yes or No.
        # -- Enrollment Agreement – A http link to the enrollment documentation.
        # -- Authorization Required – Yes or No.
        # - Provider ID Required – Yes or No.
        # - NPI Enabled – Yes or No.
        # - Last Date Modified – Last date that payer information was modified.
        #
        # <b>Note</b>: You probably need to set a long timeout to make this call
        # <b>Note</b>: I've never got this request to complete
        def payer_list
          @client.call(:get_xml_payer_list, message: {})
        end

        # Retrieves the HTTP location of payer enrollment forms for eligibility.
        def doc_links(pid)
          @client.call(:get_doc_links, message: {pid: pid})
        end
      end
    end
  end
end
