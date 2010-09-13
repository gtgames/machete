migration 1, :create_pages do
  up do
    create_table :pages do
      column :id, DataMapper::Property::Integer, :serial => true
      column :parent_id, DataMapper::Property::Integer
      column :weigth, DataMapper::Property::Integer
      column :title, DataMapper::Property::String
      column :slug, DataMapper::Property::String
      column :text, DataMapper::Property::Text
      column :text_html, DataMapper::Property::Text
      column :updated_at, DataMapper::Property::DateTime
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :pages
  end
end
