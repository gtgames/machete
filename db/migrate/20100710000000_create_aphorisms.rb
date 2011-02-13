Sequel.migration do
  up do
    create_table :aphorisms do
      primary_key :id
      String :aphorism, :size=>255
    end
  end

  down do
    drop_table :aphorisms
  end
end
