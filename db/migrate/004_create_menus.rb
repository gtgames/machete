class CreateMenus < Sequel::Migration
  def up
    create_table :menus do
      primary_key :id
      String  :title, :size=>255
      String  :alt, :size=>255
      String  :url, :size=>255
      Integer :weigth
    end
  end

  def down
    drop_table :menus
  end
end