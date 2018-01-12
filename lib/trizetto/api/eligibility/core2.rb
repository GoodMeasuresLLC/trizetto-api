require 'savon-multipart'

module Trizetto
  module Api
    module Eligibility

      # Ruby Wrapper for the CORE II Eligibility API
      #
      # Performs a real-time eligibility check using the CORE II SOAP API.  This
      # API provides an X12/270 request and receives an X12/271 response.
      #
      # As of right now, you have to generate the correct X12/271 payload.
      #
      # <b<References</b>
      #
      # - {https://mytools.gatewayedi.com/webcontent/Eligibility_Companion_Guide.pdf Eligibility 270/271 Companion Guide}
      class Core2
        def initialize(options={})
          @client = Savon.client({
            # We use a local WSDL for 1) speed and 2) the remote wsdl had a target
            # namespace that Savon consumed (SOAP UI did not).  I changed
            # targetNamespace in the WSDL to "http://www.caqh.org/SOAP/WSDL/CORERule2.2.0.xsd"
            # from "http://www.caqh.org/SOAP/WSDL/".  With that one simple change,
            # Savon is able to generate a SOAP requests that Trizetto accepts.
            # without that, you get back a 500 error and no information giving
            # insite into the error.
            wsdl:        File.join( File.dirname(__FILE__), 'core2.wsdl' ),

            endpoint:    Trizetto::Api.configuration.eligibility_core2_endpoint,

            # Digest authentication is not supported :(
            wsse_auth:   [Trizetto::Api.configuration.username, Trizetto::Api.configuration.password],

            # SOAP Version 1 sends the wrong content type header and you get back a 415 response
            soap_version: 2,

            # API maybe case sensitive - im not sure
            convert_request_keys_to: :camelcase,

            # This removes the namespace prefix in the request body nodes
            #   <CORE-XSD:PayloadType>X12_270_Request_005010X279A1</CORE-XSD:PayloadType>
            #   becomes:
            #   <PayloadType>X12_270_Request_005010X279A1</PayloadType>
            # Without this option, you get back erros like: Payload Type Required
            element_form_default: :unqualified,

            # Lots of PHI, so lets not log anything
            log: false,

            # We get back multipart responses.  You have to tell Savon that its
            # multipart, it doesn't just figure it out
            multipart: true,

          }.merge(options))
        end

        # Performs an eligiblity check using the CORE II Eligibility API via X12/270
        #
        # <b>TODO</b>
        # - Understand the X12 format and allow options to be passed in, then generate the X12 message
        #
        def check_eligibility(options = {})
          @client.call(:real_time_transaction, message: {
            'PayloadType': 'X12_270_Request_005010X279A1',
            'ProcessingMode': 'RealTime',
            'PayloadID': SecureRandom.uuid,
            'TimeStamp': Time.now.utc.xmlschema,
            'SenderID': Trizetto::Api.configuration.username,
            'ReceiverID': 'GATEWAY EDI',
            'CORERuleVersion': '2.2.0',
            'Payload': options[:payload]
          });
        end
      end
    end
  end
end
