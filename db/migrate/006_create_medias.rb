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
  end

  down do
    drop_table :media_tags
    drop_table :medias
  end
end
