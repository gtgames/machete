class CreatePages < Sequel::Migration
  def up
    create_table :pages do
      primary_key :id
      String :title, :size=>255
      String :slug, :size=>255
      Text :text
      Boolean :is_index
      Boolean :is_home
      DateTime :created_at
      DateTime :updated_at
      Integer :patent_id
      index :slug, :unique => true
    end
  end

  def down
    drop_table :pages
  end
end
