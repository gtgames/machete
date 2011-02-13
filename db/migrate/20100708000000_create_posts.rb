Sequel.migration do
  up do
    create_table :posts do
      primary_key   :id
      String        :title, :size=>255
      String        :slug, :size=>255
      Text          :text, :text => true
      DateTime      :created_at
      DateTime      :updated_at
      index :slug,  :unique => true
    end
    create_table :post_taggins do
      foreign_key :post_id, :posts
      foreign_key :tag_id, :tags
    end
  end

  down do
    drop_table :post_taggins
    drop_table :posts
  end
end
