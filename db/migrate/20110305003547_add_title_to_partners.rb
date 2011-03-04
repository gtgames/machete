Sequel.migration do
  up do
    add_column :partners, :title, String, :size => 255
  end

  down do
    drop_column :partners, :title
  end
end