require 'ostruct'

module Trizetto
  module Api
    module Eligibility
      module WebService

        # Base class for parsed reponses in the eligibility response.
        class Node < OpenStruct
          def initialize(raw_hash = {})
            raw_hash ||= {} # handle <Node/> tags - the hash comes through, but its nil

            required_keys = self.class.constants.include?(:REQUIRED_KEYS) ? self.class::REQUIRED_KEYS : {}
            clean_hash = required_keys.merge(raw_hash)

            cleanup_keys = self.class.constants.include?(:KEY_CLEANUP) ? self.class::KEY_CLEANUP : {}
            cleanup_keys.each do |uglykey, friendly_key|
              clean_hash[friendly_key] = clean_hash.delete(uglykey) if clean_hash.has_key?(uglykey)
            end

            # Convert prefixed keys "benefit_related_entity_id" to simple keys "id"
            prefix_translations = self.class.constants.include?(:PREFIX_TRANSLATIONS) ? self.class::PREFIX_TRANSLATIONS : {}
            prefix_translations.each do |key_prefix|
              clean_hash.keys.each do |key|
                if key.to_s =~ /^#{key_prefix}_(.*)$/
                  clean_hash["#{$1}".to_sym] = clean_hash.delete(key)
                end
              end
            end

            super(clean_hash)

            after_inititlize(clean_hash)
          end

          # Callback after the prased eligibility response has been cleaned up
          def after_inititlize(hash)
          end
          protected :after_inititlize
        end
      end
    end
  end
end

