module Trizetto
  module Api
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :username
      attr_accessor :password
      attr_accessor :eligibility_core2_endpoint
      attr_accessor :eligibiltiy_webservice_endpoint
      attr_accessor :payer_list_webservice_endpoint
      def initialize
        @eligibility_core2_endpoint      = "https://api.gatewayedi.com/v2/CORE_CAQH/soap"
        @eligibiltiy_webservice_endpoint = "https://services.gatewayedi.com/eligibility/service.asmx"
        @payer_list_webservice_endpoint  = "https://services.gatewayedi.com/PayerList/PayerList.asmx"
      end
    end
  end
end
