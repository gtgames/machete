Sequel.migration do
  up do
    drop_column :menus, :weight
    add_column :menus, :parent_id, Integer
    add_column :menus, :position, Integer
  end

  down do
    add_column :menus, :weight, Integer
    drop_column :menus, :parent_id
    drop_column :menus, :position
  end
end