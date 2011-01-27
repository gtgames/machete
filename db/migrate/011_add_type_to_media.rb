Sequel.migration do
  up do
    add_column :medias, :type, String
  end

  down do
    drop_column :medias, :type
  end
end