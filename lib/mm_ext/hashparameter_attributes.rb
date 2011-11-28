require 'mongo_mapper'

module MongoMapper
  module Plugins
    module HashParameterAttributes
      extend ActiveSupport::Concern

      module InstanceMethods
        def attributes=(new_attributes)
          return if new_attributes.nil?

          hash_parameter_attributes = []
          normal_attributes = {}

          new_attributes.each do |k, v|
            if k.to_s.include?("(")
              hash_parameter_attributes << [ k.to_s, v ]
            else
              normal_attributes[k] = v
            end
          end

          normal_attributes.merge! parse_hashparameter_attributes(hash_parameter_attributes)

          super(normal_attributes)
        end

        def parse_hashparameter_attributes(pairs)
          attrs = { }

          for pair in pairs
            name, value = pair
            attribute_name = name.split("(").first
            attrs[attribute_name] = {} unless attrs.include?(attribute_name)

            attrs[attribute_name].merge!({ name.scan(/\((\w+)\)/).first.first => value })
          end

          attrs
        end

      end
    end
  end
end
