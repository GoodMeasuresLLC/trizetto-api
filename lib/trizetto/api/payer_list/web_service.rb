module Trizetto
  module Api
    module PayerList

      # Ruby wrapper for the PayerList WebService
      #
      # See Also:
      #
      # - Service Documentation: https://mytools.gatewayedi.com/Help/documents/Eligibility/WS%20PayerList%20Vendor%20Toolkit.pdf
      # - WSDL: https://services.gatewayedi.com/PayerList/PayerList.asmx?WSDL
      # - Service Description: https://services.gatewayedi.com/PayerList/PayerList.asmx
      class WebService < Trizetto::Api::WebService

        def initialize(options = {})
          super(options.merge({
            wsdl:        File.join( File.dirname(__FILE__), 'web_service.wsdl' ),
            endpoint:    Trizetto::Api.configuration.payer_list_webservice_endpoint,
          }))
        end

        # Tests to see if the service is up
        #
        # See Also:
        # - Service Description https://services.gatewayedi.com/PayerList/PayerList.asmx?op=Ping
        def ping
          @client.call(:ping, message: {})
        end

        # Retrieves all Gateway EDI recognized payers along with their supported transaction types and
        # servicing states and links to their enrollment documentation, if it exists.
        #
        # Note: You probably need to set a long timeout to make this call
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
