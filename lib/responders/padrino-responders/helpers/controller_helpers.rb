module Padrino
  module Responders
    module Helpers
      module ControllerHelpers
        ##
        # Shortcut for <code>notifier.say</code> method.
        #
        def notify(kind, message, *args, &block)
          settings.notifier.say(self, kind, message, *args, &block) if settings.notifier
        end
        
        ##
        # Returns name of current action
        #
        def action_name
          name = request.route.instance_variable_get('@name').to_s
          name.gsub!(/^#{controller_name}_?/, '')
          name = 'index' if name == ''
          name
        end
        
        ##
        # Returns name of current controller
        #
        def controller_name
          request.route.controller.to_s
        end
        
        ##
        # Returns translated, human readable name for specified model. 
        #
        def human_model_name(object)
          if object.class.respond_to?(:human)
            object.class.human
          elsif object.class.respond_to?(:human_name)
            object.class.human_name 
          else
            t("models.#{object.class.to_s.underscore}", :default => object.class.to_s.humanize)
          end
        end
      end # ControllerHelpers
    end # Helpers
  end # Responders
end # Padrino
