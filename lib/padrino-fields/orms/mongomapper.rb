module PadrinoFields
  module MongoMapperWrapper
    extend ActiveSupport::Concern
    module ClassMethods
      attr_reader :reflection
      def form_attribute_validators; validators; end

      def form_validators_on(attribute)
        validators.find_all {|v| v.attributes.include? attribute}
      end

      def form_attribute_is_required?(attribute)
        form_validators_on(attribute).find_all {|v| v.class == ActiveModel::Validations::PresenceValidator }.any?
      end

      def form_reflection_validators(reflection=nil)
        new.send(reflection).validators.contexts[:default]
      end

      def form_has_required_attributes?(reflection=nil)
        validators = form_attribute_validators
        validators += reflection_validators(reflection) if reflection
        validators.find_all {|v| v.class == ActiveModel::Validations::PresenceValidator }.any?
      end

      def form_column_type_for(attribute)
        klass = keys.flatten.find_all { |k|
          k.is_a? MongoMapper::Plugins::Keys::Key
        }.find_all{ |k|
          k.name == attribute
        }
        if [Integer,Float].include?(klass)
          :number
        elsif klass == Boolean
          :boolean
        elsif [Date,DateTime].include?(klass)
          :date
        else
          :string
        end
      end

    end # ClassMethods
  end # Datamapper
end # PadrinoFields

MongoMapper::Document.plugin(PadrinoFields::MongoMapperWrapper)
