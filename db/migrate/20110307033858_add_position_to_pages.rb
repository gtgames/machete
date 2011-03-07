Sequel.migration do
  up do
    add_column :pages, :position, Integer
  end

  down do
    drop_column :pages, :position
  end
end