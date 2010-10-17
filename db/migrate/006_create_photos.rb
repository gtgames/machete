class CreatePhotos < Sequel::Migration
  def up
    create_table :photos do
      primary_key :id
      String :name, :size=>255
      String :file, :size=>255
      DateTime :created_at
      DateTime :updated_at
    end
  end

  def down
    drop_table :photos
  end
end
