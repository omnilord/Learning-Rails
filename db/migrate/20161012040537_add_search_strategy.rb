class AddSearchStrategy < ActiveRecord::Migration
  def up
    execute <<~SQL
      CREATE VIEW searches AS
        SELECT
          articles.id::TEXT AS searchable_id,
          'Article' AS searchable_type,
          'body' AS searchable_field,
          articles.body AS term
        FROM articles
        UNION
        SELECT
          articles.id::TEXT AS searchable_id,
          'Article' AS searchable_type,
          'title' AS searchable_field,
          articles.title AS term
        FROM articles
        UNION
        SELECT
          comments.id::TEXT AS searchable_id,
          'Comment' AS searchable_type,
          'body' AS searchable_field,
          comments.body AS term
        FROM comments
        UNION
        SELECT
          articles.id::TEXT AS searchable_id,
          'Article' AS searchable_type,
          'tags' AS searchable_field,
          unnest(tags) AS term
        FROM articles;

      CREATE INDEX gin_on_articles_body ON articles USING gin(to_tsvector('english', body));
      CREATE INDEX gin_on_articles_title ON articles USING gin(to_tsvector('english', title));
      CREATE INDEX gin_on_comments_body ON comments USING gin(to_tsvector('english', body));
      CREATE INDEX gin_on_tags_body ON tags USING gin(to_tsvector('english', tag));
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX gin_on_articles_body;
      DROP INDEX gin_on_articles_title;
      DROP INDEX gin_on_comments_body;
      DROP INDEX gin_on_tags_body;
      DROP VIEW searches;
    SQL
  end
end
