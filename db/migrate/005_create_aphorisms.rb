class CreateAphorisms < Sequel::Migration
  def up
    create_table :aphorisms do
      primary_key :id
      String :aphorism, :size=>255
    end
  end

  def down
    drop_table :aphorisms
  end
end
