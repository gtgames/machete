Sequel.migration do
  up do
    create_table :tags do
      String  :tag
      Integer :size
      index   :tag,  :unique => true
    end
    run <<SQLSQL-
    CREATE OR REPLACE FUNCTION tagcache()
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
    LANGUAGE plpgsql VOLATILE COST 100;

    CREATE TRIGGER tagcache_posts
      AFTER INSERT OR UPDATE ON posts
      FOR EACH STATEMENT
      EXECUTE PROCEDURE tagcache();
    CREATE TRIGGER tagcache_photos
      AFTER INSERT OR UPDATE ON photos
      FOR EACH STATEMENT
      EXECUTE PROCEDURE tagcache();
SQLSQL
  end

  down do
    run <<SQLSQL
      DROP TRIGGER tagcache_posts ON posts;
      DROP TRIGGER tagcache_photos ON photos;
      DROP FUNCTION tagcache();
SQLSQL
    drop_table :tags
  end
end

## credits: RhodiumToad (#postgresql@freenode.org)