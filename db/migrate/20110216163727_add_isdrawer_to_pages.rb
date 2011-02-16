Sequel.migration do
  up do
    add_column :pages, :is_drawer, FalseClass
  end

  down do
    remove_column :pages, :is_drawer
  end
end