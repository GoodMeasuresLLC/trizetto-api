module Trizetto
  module Api
    module Eligibility
      module WebService

        # The <PatientName> in either a Subscriber or Dependent
        #
        # <b>XML Example</b>
        #
        #   <patientname>
        #     <first>Derek</first>
        #     <middle>D</middle>
        #     <last>Walter</last>
        #     <patientaddress>1634 Maverick Glen</patientaddress>
        #     <patientcity>Starkbury</patientcity>
        #     <patientstate>IA</patientstate>
        #     <patientzip>38592</patientzip>
        #   </patientname>
        #
        # <b>Example</b>
        #
        #   patient = Patient.new(patientname: {first: 'Derek', last: 'Walter', patientaddress: '1634 Maverick Glen'})
        #   patient.name.first   # => Derek
        #   patient.name.last    # => Walter
        #   patient.name.address # => 1634 Maverick Glen
        #
        class PatientName < Node
          REQUIRED_KEYS =
          {
            first: '',
            last:  '',
          }

          KEY_CLEANUP =
          {
            patientaddress:  :address,
            patientaddress2: :address_2,
            patientcity:     :city,
            patientstate:    :state,
            patientzip:      :zip
          }

          def initialize(raw_hash = {})
            super(raw_hash)
          end
        end
      end
    end
  end
end
