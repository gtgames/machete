migration 2, :create_accounts do
  up do
    create_table :accounts do
      column :id, DataMapper::Property::Integer, :serial => true
      column :name, DataMapper::Property::String
      column :surname, DataMapper::Property::String
      column :email, DataMapper::Property::String
      column :crypted_password, DataMapper::Property::String
      column :salt, DataMapper::Property::String
      column :role, DataMapper::Property::String
    end
  end

  down do
    drop_table :accounts
  end
end
