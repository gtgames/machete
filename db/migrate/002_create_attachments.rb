class CreateAttachments < Sequel::Migration
  def up
    create_table :attachments do
      primary_key :id
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
      foreign_key :page_id, :pages
    end
  end

  def down
    drop_table :attachments
  end
end
