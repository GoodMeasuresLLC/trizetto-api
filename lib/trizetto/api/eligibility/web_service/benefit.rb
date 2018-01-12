module Trizetto
  module Api
    module Eligibility
      module WebService

        # A Benefit provided by the insurance.
        #
        # <b>Example XML</b>
        #
        #   <benefit>
        #     <info>Out of Pocket (Stop Loss)</info>
        #     <coveragelevel>Family</coveragelevel>
        #     <servicetype>Health Benefit Plan Coverage</servicetype>
        #     <servicetypecode>30</servicetypecode>
        #     <time_period_qualifier>Remaining</time_period_qualifier>
        #     <benefitamount>13097.6</benefitamount>
        #     <plannetworkindicator>In Plan-Network</plannetworkindicator>
        #     <message>BUT NO MORE THAN INDIVIDUAL AMOUNT PER MEMBER (ACCUMULATES WITH OUT-OF-NETWORK AMOUNTS)</message>
        #     <message>CALCULATION INCLUDES DEDUCTIBLE, COPAYMENTS AND COINSURANCE FOR MEDICAL AND PRESCRIPTION DRUG BENEFITS.</message>
        #   </benefit>
        #
        # <b>Example</b>
        #
        #   benefit.info     # => "Out of Pocket (Stop Loss)"
        #   benefit.messages # => ["BUT NO MORE THAN...", "CALCULATION INCLUDES ...."]
        #
        # <b>Example XML</b>
        #
        #   <benefit>
        #     <info>Active Coverage</info>
        #     <coveragelevel>Family</coveragelevel>
        #     <servicetype>Health Benefit Plan Coverage</servicetype>
        #     <servicetypecode>30</servicetypecode>
        #     <insurancetype>Preferred Provider Organization (PPO)</insurancetype>
        #     <insurancetypecode>PR</insurancetypecode>
        #     <plancoveragedescription>PPO - PREFERRED BLUE PPO SAVER</plancoveragedescription>
        #   </benefit>
        #
        # <b>Example</b>
        #
        #   benefit.info                # => "Active Coverage<"
        #   benefit.service_type_codes  # => ["30"]
        #
        class Benefit < Node
          REQUIRED_KEYS =
          {
            info:               '',
            service_type_codes: [],
            messages:           [],
          }

          KEY_CLEANUP =
          {
            benefitamount:           :benefit_amount,
            benefitentity:           :entity,
            coveragelevel:           :coverage_level,
            datequalifier:           :date_qualifier,
            insurancetype:           :insurance_type,
            insurancetypecode:       :insurance_type_code,
            plancoveragedescription: :plan_coverage_description,
            plannetworkindicator:    :plan_network_indicator,
            quantityqualifier:       :quantity_qualifier,
            servicetype:             :service_type,
            servicetypecode:         :service_type_code,
          }

          def initialize(raw_hash = {})
            clean_hash = raw_hash.dup

            # Convert message, which is either a single or multiple entry int
            # the SOAP, which then gets turned into a string or an array by
            # Nori into a messages aaray
            clean_hash[:messages] = Array(clean_hash.delete(:message)) if clean_hash.has_key?(:message)

            # Service type codes indicate the type of benefit.
            # The magic decoder for ID => human meaning is here: http://www.x12.org/codes/health-care-service-type-codes/
            # Multiple service type codes with the same benfit are combined with a ^
            # so we turn a single servicetypecode entry into an array of service types
            clean_hash[:service_type_codes] = (clean_hash.delete(:servicetypecode) || '').split("^")

            super(clean_hash)

            if self.entity.is_a?(Hash)
              self.entity = BenefitEntity.new(self.entity)
            end
          end

          # Is this active insurance coverage?
          def active_coverage?
            info == "Active Coverage"
          end

          def inactive?
            info == "Inactive"
          end

          def co_insurance?
            info == "Co-Insurance"
          end

          def limitation?
            info == "Limitations"
          end

          def non_covered?
            info == "Non-Covered"
          end

          def primary_care_provider?
            info == "Primary Care Provider"
          end
        end
      end
    end
  end
end

