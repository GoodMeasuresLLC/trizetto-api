module Trizetto
  module Api
    module Eligibility
      module WebService
        #
        # Information about the Receiver.  May include rejections
        #
        class InfoReceiver < Node
          prepend Rejectable
        end
      end
    end
  end
end
