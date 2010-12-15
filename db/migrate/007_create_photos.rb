Sequel.migration do
  up do
    create_table :photos do
      primary_key :id
      String :name, :size=>255
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
    end
    create_table :photo_taggins do
      foreign_key :photo_id, :photos
      foreign_key :tag_id, :tags
    end
  end

  down do
    drop_table :photo_taggins
    drop_table :photos
  end
end
