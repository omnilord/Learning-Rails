class FixTagTriggers < ActiveRecord::Migration
  def up
    execute <<~SQL
      CREATE OR REPLACE FUNCTION update_tags()
      RETURNS trigger AS $end_trigger$
      DECLARE
        rtags text[];
        atags text[];
        ntag text;
      BEGIN
        IF (TG_OP = 'INSERT') THEN
          rtags := ARRAY[]::text[];
          atags := COALESCE(NEW.tags, ARRAY[]::text[]);
        ELSIF (TG_OP = 'DELETE') THEN
          rtags := COALESCE(OLD.tags, ARRAY[]::text[]);
          atags := ARRAY[]::text[];
        ELSIF (TG_OP = 'UPDATE') THEN
          rtags := ARRAY(
                          SELECT unnest(COALESCE(OLD.tags, ARRAY[]::text[]))
                          EXCEPT
                          SELECT unnest(COALESCE(NEW.tags, ARRAY[]::text[]))
                        );
          atags := ARRAY(
                          SELECT unnest(COALESCE(NEW.tags, ARRAY[]::text[]))
                          EXCEPT
                          SELECT unnest(COALESCE(OLD.tags, ARRAY[]::text[]))
                        );
        ELSE
          RAISE EXCEPTION 'Unknown, unexpected TG_OP value in update_tags.';
        END IF;

        -- First subtract where tags were removed
        IF array_length(rtags, 1) > 0 THEN
          FOREACH ntag IN ARRAY rtags LOOP
            UPDATE tags SET volume=CASE volume WHEN 0 THEN 0 ELSE volume - 1 END
              WHERE tags.tag=ntag;
          END LOOP;
        END IF;

        -- Then add where tags were added
        IF array_length(atags, 1) > 0 THEN
          FOREACH ntag IN ARRAY atags LOOP
            UPDATE tags SET volume=volume+1 WHERE tags.tag=ntag;
            IF NOT FOUND THEN
              INSERT INTO tags VALUES(ntag, 1);
            END IF;
          END LOOP;
        END IF;

        RETURN NEW;
      END;
      $end_trigger$ LANGUAGE plpgsql;

      DROP TRIGGER maintain_tag_counts_on_insert ON articles;
      DROP TRIGGER maintain_tag_counts_on_update ON articles;
      DROP TRIGGER maintain_tag_counts_on_delete ON articles;

      CREATE TRIGGER maintain_tag_counts_on_insert AFTER INSERT ON articles
      FOR EACH ROW WHEN (NEW.tags IS NOT NULL AND NEW.tags <> '{}')
      EXECUTE PROCEDURE update_tags();

      CREATE TRIGGER maintain_tag_counts_on_update AFTER UPDATE OF tags ON articles
      FOR EACH ROW WHEN (OLD.tags IS DISTINCT FROM NEW.tags)
      EXECUTE PROCEDURE update_tags();

      CREATE TRIGGER maintain_tag_counts_on_delete AFTER DELETE ON articles
      FOR EACH ROW WHEN (OLD.tags IS NOT NULL AND OLD.tags <> '{}')
      EXECUTE PROCEDURE update_tags();
    SQL
  end

  def down
  end
end
