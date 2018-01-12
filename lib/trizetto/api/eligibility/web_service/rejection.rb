module Trizetto
  module Api
    module Eligibility
      module WebService

        # A rejection in the eligibility response.
        #
        # <b>Example XML</b>
        #   <rejection>
        #     <rejectreason>Subscriber/Insured Not Found</rejectreason>
        #     <followupaction>Please Correct and Resubmit</followupaction>
        #   </rejection>
        #
        # @see Rejectable
        class Rejection < Node
          KEY_CLEANUP =
          {
            rejectreason:   :reason,
            followupaction: :follow_up_action,
          }

          attr_accessor :source

          def initialize(raw_hash = {})
            super(raw_hash)
          end
        end
      end
    end
  end
end
