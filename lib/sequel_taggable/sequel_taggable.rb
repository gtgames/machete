module Sequel
  module Plugins
    module Taggable
      # Apply the plugin to the model.
      def self.apply(model, options = {})
      end

      module InstanceMethods
        def tag_list
          self.tags
        end
        def tag_list=(string)
          self.tags = string.split(',').map {|n|
            n.gsub(/[^\w\s_-]/i, '').strip.downcase
          }.uniq.sort.join(', ')
        end
      end

      module ClassMethods
        def tagged_with tag
          full_text_search([:tags], tag.gsub(/\s/, ' & ')).all
        end
      end # ClassMethods
    end # Taggable
  end # Plugins
end # Sequel
