Sequel.migration do
  up do
    alter_table :posts do
      add_full_text_index :tags
    end
    alter_table :photos do
      add_full_text_index :tags
    end
  end

  down do
  end
end