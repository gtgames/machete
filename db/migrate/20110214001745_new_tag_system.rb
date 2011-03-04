Sequel.migration do
  up do
    drop_table :post_taggins, :photo_taggins, :tags
    
    add_column :posts,  :tags, String, :size => 400
    add_column :photos, :tags, String, :size => 400
  end

  down do
    create_table :tags do
      primary_key :id
      String     :name, :null => false
    end
    create_table :post_taggins do
      foreign_key :post_id, :posts
      foreign_key :tag_id, :tags
    end
    create_table :photo_taggins do
      foreign_key :photo_id, :photos
      foreign_key :tag_id, :tags
    end
  end
end