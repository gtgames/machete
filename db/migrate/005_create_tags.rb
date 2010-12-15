=begin
Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String      :name, :size => 255
      index       :name, :unique => true
    end
  end

  down do
    drop_table :tags
  end
end
=end

Sequel.migration do
  up do
    create_table :tags do
      primary_key :id
      String     :name, :null => false
    end
  end
  down do
    drop_table :tags
  end
end