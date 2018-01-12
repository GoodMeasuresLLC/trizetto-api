module Trizetto
  module Api
    module Eligibility
      module WebService
        #
        # Information about the Source.  May include rejections
        #
        class InfoSource < Node
          prepend Rejectable
        end
      end
    end
  end
end
