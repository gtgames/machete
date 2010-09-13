migration 3, :create_menus do
  up do
    create_table :menus do
      column :id, DataMapper::Property::Integer, :serial => true
      column :title, DataMapper::Property::String
      column :alt, DataMapper::Property::String
      column :url, DataMapper::Property::String
      column :weigth, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :menus
  end
end
