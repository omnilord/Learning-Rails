class PreventPopulatedTagDeletion < ActiveRecord::Migration
  def up

    execute <<~SQL
      CREATE OR REPLACE RULE prevent_populated_tag_deletion_on_delete
        AS ON DELETE TO tags WHERE OLD.volume > 0 DO INSTEAD NOTHING;
    SQL
  end

  def down
    execute <<~SQL
      DROP RULE IF EXISTS prevent_populated_tag_deletion_on_delete ON tags;
    SQL
  end
end
