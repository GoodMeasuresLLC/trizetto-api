module Trizetto
  module Api
    module Eligibility
      module WebService

        # A Patient is either a Subscriber or Depedent.  This is the common
        # attributes between the two
        class Patient < Node

          # @see PatientName
          attr_accessor :name

          # The benefits this patient has.
          #
          attr_accessor :benefits

          KEY_CLEANUP = {
            :patientid => :id
          }

          def initialize(raw_hash = {})
            super(raw_hash)
            self.name = PatientName.new(raw_hash[:patientname]) if raw_hash.has_key?(:patientname)

            benefits_xml = raw_hash[:benefit] || []
            benefits_xml = [benefits_xml] if benefits_xml.is_a?(Hash)

            self.benefits = benefits_xml.map do |benefit_xml|
              Benefit.new(benefit_xml)
            end
          end
        end
      end
    end
  end
end
