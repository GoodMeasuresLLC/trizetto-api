module Trizetto
  module Api
    module Eligibility
      module WebService
        # A dependent in the eligibility XML.
        #
        # <b>NOTE: Not all fields have been transcribed to objects</b>
        #
        # <b>Example XML</b>
        #
        #   <dependent>
        #     <trace_number>999999999</trace_number>
        #     <trace_id>99TRIZETTO</trace_id>
        #     <subscriberaddinfo>
        #       <subsupplementalid>99</subsupplementalid>
        #       <grouppolicynum>999</grouppolicynum>
        #     </subscriberaddinfo>
        #     <subscriberaddinfo>
        #       <subsupplementalid>6P</subsupplementalid>
        #       <grouppolicynum>999999999A6AG999</grouppolicynum>
        #       <plansponsorname>BERGE-GREENHOLT</plansponsorname>
        #     </subscriberaddinfo>
        #     <date>
        #       <datequalifier>Plan</datequalifier>
        #       <date-of-service>20160101-99991231</date-of-service>
        #     </date>
        #     <date>
        #       <datequalifier>Service</datequalifier>
        #       <date-of-service>20180116</date-of-service>
        #     </date>
        #     <patientname>
        #       <first>JUANA</first>
        #       <middle>M</middle>
        #       <last>ORN</last>
        #     </patientname>
        #     <sex>F</sex>
        #     <date-of-birth>19630717</date-of-birth>
        #     <relationship>
        #       <insuredindicator>No</insuredindicator>
        #       <relationshipcode>Spouse</relationshipcode>
        #       <relationshiptypecode>Change</relationshiptypecode>
        #       <relationshipreasoncode>Change in Identifying Data Elements</relationshipreasoncode>
        #     </relationship>
        #     <benefit>
        #       <info>Active Coverage</info>
        #       <coveragelevel>Employee and Spouse</coveragelevel>
        #       <servicetype>Health Benefit Plan Coverage</servicetype>
        #       <servicetypecode>30</servicetypecode>
        #       <insurancetype>Preferred Provider Organization (PPO)</insurancetype>
        #       <insurancetypecode>PR</insurancetypecode>
        #       <plancoveragedescription>CDHP</plancoveragedescription>
        #     </benefit>
        #   </dependent>
        #
        # <b>Example</b>
        #
        #   dependent.trace_number   # => "999999999"
        #   dependent.name.first     # => "JUNNA"
        #   dependent.name.middle    # => "M"
        #   dependent.name.last      # => "ORN"
        #   dependent.name.sex       # => "F"
        #   dependent.name.benefits  # => [ Array of Benefits ]
        class Dependent < Patient
          def initialize(raw_hash = {})
            super(raw_hash)
          end
        end
      end
    end
  end
end

