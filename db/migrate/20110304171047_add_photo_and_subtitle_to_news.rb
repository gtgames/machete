Sequel.migration do
  up do
    add_column :posts, :subtitle, String
    add_column :posts, :photo, String, :size => 255
  end

  down do
    drop_column :posts, :subtitle
    drop_column :posts, :photo
  end
end