module Trizetto
  module Api
    module Eligibility
      module WebService

        # Rejections appear in a few places in the eligibility response.
        # Any node that can have a rejection should prepend this module
        #
        # *Example*
        #  class InfoReciever < Node
        #    prepend Rejectable
        #  end
        #
        # <b>Example XML</b>
        #   <infosource>
        #     <rejection>
        #       <rejectreason>Unable to Respond at Current Time</rejectreason>
        #       <followupaction>Resubmission Allowed</followupaction>
        #     </rejection>
        #   <i/nfosource>
        #
        # <b>Example XML</b>
        #   <inforeceiver>
        #     <rejection>
        #       <rejectreason>Provider Not on File</rejectreason>
        #       <followupaction>Please Correct and Resubmit</followupaction>
        #     </rejection>
        #   </inforeceiver>
        #
        # <b>Example XML</b>
        #   <subscriber>
        #     <rejection>
        #       <rejectreason>Invalid/Missing Subscriber/Insured Name</rejectreason>
        #       <followupaction>Please Correct and Resubmit</followupaction>
        #     </rejection>
        #     <rejection>
        #       <rejectreason>Patient Birth Date Does Not Match That for the Patient on the Database</rejectreason>
        #       <followupaction>Please Correct and Resubmit</followupaction>
        #     </rejection>
        #   </subscriber>
        #
        module Rejectable
          def after_inititlize(hash)
            super(hash)

            # This is in an openstruct and after inititalize, :rejection in the
            # hash will have created an accessor, so nil that out here, we're using
            # rejections (plural) not rejection (singular)
            self.rejection = nil

            rejections_xml = hash[:rejection] || []
            rejections_xml = [rejections_xml] if rejections_xml.is_a?(Hash)

            self.rejections = rejections_xml.map do |rejection_xml|
              Rejection.new(rejection_xml).tap {|r| r.source = self }
            end
          end
        end
      end
    end
  end
end
