class CreatePosts < Sequel::Migration
  def up
    create_table :posts do
      primary_key   :id
      String        :title, :size=>255
      String        :slug, :size=>255
      Text          :text, :text => true
      DateTime      :created_at
      DateTime      :updated_at
      index :slug,  :unique => true
    end
  end

  def down
    drop_table :posts
  end
end
