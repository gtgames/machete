migration 5, :create_uploads do
  up do
    create_table :uploads do
      column :id, DataMapper::Property::Integer, :serial => true
      column :file, DataMapper::Property::Text
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :uploads
  end
end
