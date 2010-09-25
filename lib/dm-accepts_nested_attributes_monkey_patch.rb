module DataMapper
  module NestedAttributes
    module Resource
      def update_or_mark_as_destroyable(relationship, resource, attributes)
        allow_destroy = self.class.options_for_nested_attributes[relationship][:allow_destroy]
        if has_delete_flag?(attributes) && allow_destroy
          if relationship.is_a?(DataMapper::Associations::ManyToMany::Relationship)
            intermediaries = relationship.through.get(self).all(relationship.via => resource)
            intermediaries.each { |intermediate| destroyables << intermediate }
          end
          destroyables << resource
        else
          resource.reload.update(attributes.except(*unassignable_keys))
        end
      end
    end
  end
end