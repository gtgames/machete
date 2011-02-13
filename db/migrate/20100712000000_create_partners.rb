Sequel.migration do
  up do
    create_table :partners do
      primary_key :id
      String :url,  :size=>255
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :partners
  end
end