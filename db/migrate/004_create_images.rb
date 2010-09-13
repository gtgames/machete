migration 4, :create_images do
  up do
    create_table :images do
      column :id, DataMapper::Property::Integer, :serial => true
      column :title, DataMapper::Property::String
    end
  end

  down do
    drop_table :images
  end
end
