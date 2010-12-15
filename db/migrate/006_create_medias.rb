Sequel.migration do
  up do
    create_table :medias do
      primary_key :id
      String    :name, :size=>255
      Text      :description
      String    :file, :size=>255
      DateTime  :created_at
      DateTime  :updated_at
    end
    create_table :media_taggins do
      foreign_key :media_id, :medias
      foreign_key :tag_id, :tags
    end
  end

  down do
    drop_table :media_taggins
    drop_table :medias
  end
end
