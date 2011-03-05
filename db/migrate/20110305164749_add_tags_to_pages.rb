Sequel.migration do
  up do
    add_column :partners, :title, String, :size => 255
    run "
    REPLACE FUNCTION tagcache()
      RETURNS trigger AS
    $BODY$
      BEGIN
        TRUNCATE tags;
        INSERT INTO tags SELECT tag,count(*) FROM (
          SELECT regexp_split_to_table(tags,'[[:space:]]*,[[:space:]]*') FROM photos
          UNION ALL
          SELECT regexp_split_to_table(tags,'[[:space:]]*,[[:space:]]*') FROM posts
          UNION ALL
          SELECT regexp_split_to_table(tags,'[[:space:]]*,[[:space:]]*') FROM pages
        ) s(tag) GROUP BY tag;
      return NULL;
    END;
    $BODY$
    LANGUAGE plpgsql VOLATILE COST 100;

    CREATE TRIGGER tagcache_pages
      AFTER INSERT OR UPDATE ON pages
      FOR EACH STATEMENT
      EXECUTE PROCEDURE tagcache();"
  end

  down do
    drop_column :pages, :tags
    run "DROP TRIGGER tagcache_pages ON pages;
    
    REPLACE FUNCTION tagcache()
      RETURNS trigger AS
    $BODY$
      BEGIN
        TRUNCATE tags;
        INSERT INTO tags SELECT tag,count(*) FROM (
          SELECT regexp_split_to_table(tags,'[[:space:]]*,[[:space:]]*') FROM photos
          UNION ALL
          SELECT regexp_split_to_table(tags,'[[:space:]]*,[[:space:]]*') FROM posts
        ) s(tag) GROUP BY tag;
      return NULL;
    END;
    $BODY$
    LANGUAGE plpgsql VOLATILE COST 100;"
  end
end
