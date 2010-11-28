class CreatePostTags < Sequel::Migration
  def up
    create_table :post_tags do
      primary_key :id
      String      :title, :size=>255
      index       :title,  :unique => true
    end
    create_table :post_tags_posts do
      primary_key :id
      foreign_key :post_id, :posts
      foreign_key :post_tag_id, :post_tags
    end
  end

  def down
    drop_table :post_tags
    drop_table :post_tags_posts
  end
end
