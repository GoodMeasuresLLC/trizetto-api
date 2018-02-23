require 'savon'

module Trizetto
  module Api

    # Base class for WebService API requests
    class WebService # :nodoc:
      def initialize(options = {})
        @client = Savon.client({
          # SOAP Version 1 sends the wrong content type header and you get back a 415 response
          soap_version: 2,

          soap_header: { "tns:AuthSOAPHeader": {
            "tns:User":     Trizetto::Api.configuration.username,
            "tns:Password": Trizetto::Api.configuration.password
          }},

          # API maybe case sensitive - im not sure
          convert_request_keys_to: :none,

          ssl_version:  :TLSv1_2,

          # Lots of PHI, so lets not log anything
          log: false,
        }.merge(options))
      end
    end
  end
end
