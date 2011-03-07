Sequel.migration do
  up do
    add_column :media, :type, String
  end

  down do
    drop_column :media, :type
  end
end