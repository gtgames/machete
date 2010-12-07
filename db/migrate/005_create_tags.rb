=begin
Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String      :name, :size => 255
      index       :name, :unique => true
    end
  end

  down do
    drop_table :tags
  end
end
=end

Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String     :name, :null => false
    end
    
    create_table :taggings do
      primary_key :id
      Integer     :tag_id,        :null => false
      Integer     :taggable_id,   :null => false
      String      :taggable_type, :size => 255, :null => false
      #varchar :tag_context, :null => false
      
      #datetime :created_at #TODO decide on using is_timestamped plugin to autofill this
      index [:tag_id, :taggable_id, :taggable_type]
    end
  end

  down do
    drop_table :tags
    drop_table :taggings
  end
end