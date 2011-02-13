Sequel.migration do
  up do
    create_table :medias do
      primary_key :id
      String    :file, :size=>255
      DateTime  :created_at
      DateTime  :updated_at
    end
  end

  down do
    drop_table :medias
  end
end
