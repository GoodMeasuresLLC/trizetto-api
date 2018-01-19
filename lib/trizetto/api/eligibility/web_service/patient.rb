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
          attr_accessor :benefits

          # The traces, by source (uppercased), in the response
          #
          # *Example*
          #
          #   patient.traces  # => {"99TRIZETTO" => "812341292"}
          #
          # *Example*
          #
          #   patient.trace_number("99TRIZETTO")  # => "812341292"
          #   patient.trace_number("99Trizeeto")  # => "812341292"
          attr_accessor :traces

          KEY_CLEANUP = {
            :patientid => :id
          }

          def initialize(raw_hash = {})
            trace_ids, trace_numbers = Array(raw_hash.delete(:trace_id)), Array(raw_hash.delete(:trace_number))

            super(raw_hash)

            self.name = PatientName.new(raw_hash[:patientname]) if raw_hash.has_key?(:patientname)

            benefits_xml = raw_hash[:benefit] || []
            benefits_xml = [benefits_xml] if benefits_xml.is_a?(Hash)

            self.benefits = benefits_xml.map do |benefit_xml|
              Benefit.new(benefit_xml)
            end

            self.traces = {}
            if trace_ids.length == trace_numbers.length
              trace_ids.each.with_index do |id, index|
                traces[id.upcase] = trace_numbers[index]
              end
            end
          end

          # Looks for a trace number by trace_id (who added the trace).
          #
          # @return [String]
          def trace_number(trace_id="99Trizetto")
            self.traces[trace_id&.upcase]
          end
        end
      end
    end
  end
end
