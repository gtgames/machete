class CreateMedias < Sequel::Migration
  def up
    create_table :medias do
      primary_key :id
      String :name, :size=>255
      Text :description
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
    end
  end

  def down
    drop_table :medias
  end
end
