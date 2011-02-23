Sequel.migration do
  up do
    add_column :attachments, :name, String
  end

  down do
    drop_column :attachments, :name
  end
end