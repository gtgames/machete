module Sequel
  module Plugins
    module Taggable
      # Apply the plugin to the model.
      def self.apply(model, options = {})
      end

      module InstanceMethods
        def tag_list
          if @frozen_tag_list.nil?
            tgs = []
            self.tags.each do |t|
              tgs << t.name
            end
            tgs.join ', '
          else
            @frozen_tag_list
          end
        end
        def tag_list=(string)
          @frozen_tag_list = string
        end

        def add_tags (tlist)
          tlist.to_s.split(',').map {|n|
            n.gsub(/[^\w\s_-]/i, '').strip
          }.uniq.sort.each{|o|
            add_tag Tag.find_or_create(:name => o)
          }
        end
        def after_save
          super
          add_tags @frozen_tag_list
        end
      end

      module ClassMethods
      end # ClassMethods
    end # Taggable
  end # Plugins
end # Sequel
    