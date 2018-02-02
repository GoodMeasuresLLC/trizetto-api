module Trizetto
  module Api
    module Eligibility
      module WebService
        class AdditionalInfo < Node
          KEY_CLEANUP = {
            subsupplementalid: :id,
            grouppolicynum:    :group_policy_number,
            plansponsorname:   :plan_sponsor_name,
          }
        end
      end
    end
  end
end

