module Trizetto
  module Api
    module Eligibility
      module WebService

        # The parsed response from an eligibility check
        class DoInquiryResponse

          # The SuccessCode in the XML response from the eligibility request.
          #
          # Takes on one of these values
          # * <tt>Success</tt>                    - The request was well formed and  not missing any fields
          # * <tt>ValidationFailure</tt>          - The request was not valid. Maybe a field  was formatted incorrectly or omitted.
          # * <tt>PayerTimeout</tt>               - ?
          # * <tt>PayerNotSupported</tt>          - ?
          # * <tt>SystemError</tt>                - ?
          # * <tt>PayerEnrollmentRequired</tt>    - ?
          # * <tt>ProviderEnrollmentRequired</tt> - ?
          # * <tt>ProductRequired</tt>            - ?
          attr_accessor :success_code

          # For a successful request that returned an eligibility response, the
          # transaction identifier from Trizetto.  Seems to be 30 random alpha
          # numeric characters
          attr_accessor :transaction_id

          # For a successful request, the name of the payer (insurance company)
          attr_accessor :payer_name

          # For a successful request, the identifier of the payer (insurance company)
          attr_accessor :payer_id

          # Any validation error or messages provided in the response
          #
          # *Example*
          #   client.extra_processing_info.messages                                  # => ["Invalid InsuredFirstName Length."]
          #   client.extra_processing_info.validation_failures.first.affected_fields # => ["InsuredFirstName"]
          #   client.extra_processing_info.validation_failures.first.message         # => "Invalid InsuredFirstName Length."
          #
          # @see ExtraProcessingInfo
          #
          attr_accessor :extra_processing_info

          # The eligibility response xml parsed into a hash.
          attr_accessor :eligibility_response_as_hash

          # The Subscriber in the eligibility XML.
          #
          # @see Subscriber
          attr_accessor :subscriber

          # The Dependent in the eligibility XML.
          #
          # @see Dependent
          attr_accessor :dependent

          # The infosource in the eligibilty XML
          #
          # @see InfoSource
          attr_accessor :info_source

          # The inforeceiver in the eligibilty XML
          #
          # @see InfoReceiver
          attr_accessor :info_receiver

          # The full XML response from Trizetto if it was provided.
          attr_accessor :raw_xml

          # Parses the SOAP response from a DoInquiry request into ruby objects
          #
          # *Example*
          #
          #    DoInquiryResponse.new({
          #       do_inquiry_response: {
          #         do_inquiry_result: {
          #           success_code: "Success",
          #           response_as_xml: "...",
          #           extra_processing_info: { ... }
          #         }
          #       }
          #    })
          #
          # *Example*
          #
          #    client = Savon.client.new(...)
          #    savon_response = client.call( :do_inquiry, message: {...} )
          #    DoInquiryResponse.new(savon_response.body, savon_response.to_xml)
          #
          # *Example*
          #
          #    parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
          #    raw_xml = File.read( xml_saved_on_disk_path )
          #    body = parser.parse(raw_xml).dig(:"soap:envelope", :"soap:body")
          #    DoInquiryResponse.new(body, raw_xml)
          #
          # @param body [Hash] the body of the SOAP request.
          # @param xml [string] the raw XML of the SOAP request including the envelope
          def initialize(body, xml = nil)
            self.raw_xml = xml

            response = body.dig(:do_inquiry_response, :do_inquiry_result) || {}

            self.success_code    = response[:success_code]
            self.response_as_xml = response[:response_as_xml]
            self.extra_processing_info = ExtraProcessingInfo.new(response[:extra_processing_info])
          end

          def response_as_xml=(eligibility_response_xml_as_string)
            parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
            self.eligibility_response_as_hash = parser.parse(eligibility_response_xml_as_string || '')[:eligibilityresponse] || {}

            self.transaction_id = eligibility_response_as_hash.dig(:infosource, :transactionid)
            self.payer_name     = eligibility_response_as_hash.dig(:infosource, :payername)
            self.payer_id       = eligibility_response_as_hash.dig(:infosource, :payerid)

            # TODO: I have not yet been able to find an example of multiple subscribers
            # in a response from trizetto.  But, I think if there were multiple
            # subscribers matching a queruy, the would come back as <subscriber>...</subscriber><subscriber>...</subscriber>
            # which Nori will turn into an array (subscriber: [...]).

            if subscriber_xml = eligibility_response_as_hash[:subscriber]
              raise MultipleSubscribersError if subscriber_xml.is_a?(Array)
              self.subscriber = Subscriber.new(subscriber_xml)
            end

            if dependent_xml = eligibility_response_as_hash[:dependent]
              raise MultipleDependentsError if dependent_xml.is_a?(Array)
              self.dependent = Dependent.new(dependent_xml)
            end

            if info_source_xml = eligibility_response_as_hash[:infosource]
              self.info_source = InfoSource.new(info_source_xml)
            end

            if info_receiver_xml = eligibility_response_as_hash[:inforeceiver]
              self.info_receiver = InfoReceiver.new(info_receiver_xml)
            end
          end
          protected :response_as_xml=

          # Did we successfully get back an eligibility response from the payer.
          #
          # This does not mean the patient has active coverage.
          #
          # @return Boolean
          def success?
            success_code == 'Success' && [transaction_id, payer_name, payer_id].none?(&:blank?)
          end

          # The dependent or the subscriber - the best guess at who is the patient
          def patient
            dependent || subscriber
          end

          # Was the eligibility check rejected.  Eligibility checks may be rejected
          # because they have expired, they don't exist, the payer service is unable
          # to response, or there were errors with the request handled at the
          # payer level instead of through Trizetto.  There can be _multiple_ rejections
          # on a single request
          #
          # @see #rejections
          def rejected?
            !rejections.empty?
          end

          # Rejections can appear in the subscriber, info source, info receiver,
          # and possibly in the dependent.  Additionaly, there can be _multiple_
          # rejections in any one of those.  This collects them all
          def rejections
            [subscriber, dependent, info_receiver, info_source].compact.map(&:rejections).flatten.compact
          end

          # Validation errors handled at Trizetto's level
          #
          # @return ExtraProcessingInfo
          def errors
            self.extra_processing_info
          end

          # Does the patient we asked about have active insurance coverage for
          # this service type code?  Service type codes are strings and the
          # most common is 30, general health benefits coverage.
          #
          # <b>Example</b>
          #
          #   response.active_coverage_for?("30")  #=> true
          #
          # <b>References</b>
          #
          # * {http://www.x12.org/codes/health-care-service-type-codes/ Service Type Code Reference<}
          def active_coverage_for?(service_type_code)
            !!(patient && patient.benefits.any? do |benefit|
              benefit.active_coverage? && benefit.service_type_codes.include?(service_type_code.to_s)
            end)
          end

          # Trizetto adds a trace number to the subscriber or dependent that can
          # be given to them later as part of a support request.  Additionally
          # the payer may add a trace.  All the traces are available through
          # `patient.traces`
          #
          # <b>Example</b>
          #
          #   response.trace_number               # => "81238881"
          #   response.trace_number('99Trizetto') # => "81238881"
          #   response.traces                     # => {"99TRIZETTO": "81238881"}
          #
          # @return [String] - a number that can be given to support for help with this request
          def trace_number(trace_id="99Trizetto")
            patient&.trace_number(trace_id)
          end
        end
      end
    end
  end
end
