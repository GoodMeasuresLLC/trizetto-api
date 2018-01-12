module Trizetto
  module Api
    module Eligibility
      module WebService

        # When a benefit is related to an entity, such as a primary care provider,
        # the entity details are captured here
        #
        # <b>Example XML</b>
        #   <benefitentity>
        #     <entitycode>Primary Care Provider</entitycode>
        #     <name>JULIUS</name>
        #     <first>GROLLMAN</first>
        #     <identification_code_qualifier>Health Care Financing Administration National Provider Identifier</identification_code_qualifier>
        #     <benefit_related_entity_id>1609858695</benefit_related_entity_id>
        #     <benefit_related_entity_address_1>4101 TORRANCE BLVD</benefit_related_entity_address_1>
        #     <benefit_related_entity_city>TORRANCE</benefit_related_entity_city>
        #     <benefit_related_entity_state>CA</benefit_related_entity_state>
        #     <benefit_related_entity_zip>90503</benefit_related_entity_zip>
        #     <communicationnumberqualifier>Telephone</communicationnumberqualifier>
        #     <communicationnumber>3103035750</communicationnumber>
        #   </benefitentity>
        #
        # <b>Example</b>
        #   benefit.entity.entity_code                   # => "Primary Care Provider"
        #   benefit.entity.name                          # => "JULIUS"
        #   benefit.entity.first                         # => "GROLLMAN"
        #   benefit.entity.id                            # => "1609858695"
        #   benefit.entity.identification_code_qualifier # => "Health Care Financing Administration National Provider Identifier"
        #   benefit.entity.city                          # => "TORRANCE"
        #   benefit.entity.communication_number          # => "3103035750"
        #
        class BenefitEntity < Node
          KEY_CLEANUP =
          {
            entitycode:                   :entity_code,
            communicationnumberqualifier: :communication_number_qualifier,
            communicationnumber:          :communication_number,
          }

          PREFIX_TRANSLATIONS =
          [
            :benefit_related_entity
          ]

          def initialize(raw_hash = {})
            super(raw_hash)
          end
        end
      end
    end
  end
end

