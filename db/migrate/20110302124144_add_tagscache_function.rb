Sequel.migration do
  up do
    run <<SQLSQL
    CREATE OR REPLACE FUNCTION tagcache()
      RETURNS TRIGGER AS
    $BODY$
    DECLARE
      r RECORD;
      query varchar(4000);
    BEGIN
      TRUNCATE tags;
      query := 'SELECT tag FROM regexp_split_to_table(array_to_string((array(SELECT photos.tags FROM photos) || array(SELECT posts.tags FROM posts)), '', ''), E''\\\\\\\\s*,\\\\\\\\s*'') AS tag';
      FOR r IN EXECUTE query LOOP
        IF (SELECT COUNT (tags.tag) FROM tags WHERE tags.tag = r.tag) < 1 THEN
          INSERT INTO tags ("tag", "size") VALUES ( r.tag, 1 );
        ELSE
          UPDATE tags SET size = size+1 WHERE tag = r.tag ;
        END IF;
      END LOOP;
      return NULL;
    END;
    $BODY$
      LANGUAGE plpgsql VOLATILE
      COST 100;
    ALTER FUNCTION tagcache() OWNER TO postgres;
    
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
      DROP TRIGGER tagcache_posts;
      DROP TRIGGER tagcache_photos;
      DROP FUNCTION tagcache();
SQLSQL
  end
end
=begin

-- Function: tagcache()

--DROP FUNCTION tagcache();

CREATE OR REPLACE FUNCTION tagcache(varchar)
  RETURNS character varying AS
$BODY$
DECLARE
  r RECORD;
  t ALIAS FOR $1;
  query varchar(4000);
BEGIN
  query := 'SELECT tag FROM regexp_split_to_table(array_to_string(array(SELECT ' || t || '.tags AS tag FROM '|| t ||'), '' ,''), E''\\s*,\\s*'') AS tag';

  --RAISE NOTICE 'Query:  %', query;

  FOR r IN EXECUTE query LOOP
    IF (SELECT COUNT (tags.tag) FROM tags WHERE tags.tag = r.tag) < 1 THEN
      INSERT INTO tags ("tag", "size") VALUES ( r.tag, 1 );
    ELSE
      UPDATE tags SET size = size+1 WHERE tag = r.tag ;
    END IF;
  END LOOP;
  return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tagcache() OWNER TO postgres;

=end