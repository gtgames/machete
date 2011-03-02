Sequel.migration do
  up do
    run <<SQL
      CREATE TRIGGER tagcache_posts
        AFTER CREATE OR UPDATE ON posts
        FOR EACH STATEMENT
        EXECUTE PROCEDURE tag_cache();
      CREATE TRIGGER tagcache_photos
        AFTER CREATE OR UPDATE ON photos
        FOR EACH STATEMENT
        EXECUTE PROCEDURE tag_cache();
    SQL
  end

  down do
    run <<SQL
      DROP TRIGGER tagcache_posts;
      DROP TRIGGER tagcache_photos;
    SQL
  end
end