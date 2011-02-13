Sequel.migration do
  up do
    create_table :menus do
      primary_key :id
      String  :title, :size=>255
      String  :alt, :size=>255
      String  :url, :size=>255
      Integer :weight
    end
  end

  down do
    drop_table :menus
  end
end