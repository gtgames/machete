Sequel.migration do
  up do
    create_table :pages do
      primary_key :id
      String      :title, :size=>255
      String      :slug,  :size=>255
      Text        :text,  :text => true
      Boolean     :is_index
      Boolean     :is_home
      DateTime    :created_at
      DateTime    :updated_at
      Integer     :parent_id
      index :slug, :unique => true
    end
  end

  down do
    drop_table :pages
  end
end
