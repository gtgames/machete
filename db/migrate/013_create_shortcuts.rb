Sequel.migration do
  up do
    create_table :shortcuts do
      primary_key :id
      String  :title,  :size=>255
      Integer :url,    :size=>255
    end
  end

  down do
    drop_table :shortcuts
  end
end