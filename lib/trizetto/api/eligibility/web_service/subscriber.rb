module Trizetto
  module Api
    module Eligibility
      module WebService

        # The subscriber is who holds the insurance.  They may be the patient, or
        # they may have dependents who are the patients.
        class Subscriber < Patient
          prepend Rejectable

          def initialize(raw_hash = {})
            # If we are in subscriber / depdent relationship, we get back subscribername
            # instead of patientname (as the subscriber is _not_ the patient).  For
            # convience, we'll transform the subscriber name into a name

            clean_hash = raw_hash.dup
            if clean_hash.has_key?(:subscribername) && !clean_hash.has_key?(:patientname) && clean_hash[:subscribername].is_a?(Hash)
              clean_hash[:patientname] = clean_hash.delete(:subscribername)
              clean_hash[:patientname].keys.each do |key|
                if key.to_s =~ /^subscriber(.*)$/
                  clean_hash[:patientname]["patient#{$1}".to_sym] = clean_hash[:patientname].delete(key)
                end
              end
            end
            super(clean_hash)
          end
        end
      end
    end
  end
end
