Sequel.migration do
  up do
    add_column :pages, :is_drawer, FalseClass
  end

  down do
    drop_column :pages, :is_drawer
  end
end