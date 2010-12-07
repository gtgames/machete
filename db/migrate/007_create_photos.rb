Sequel.migration do
  up do
    create_table :photos do
      primary_key :id
      String :name, :size=>255
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :photos
  end
end
