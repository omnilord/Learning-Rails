class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.timestamps
      t.text :username
      t.text :email
    end

    add_foreign_key :articles, :users, on_delete: :restrict, on_update: :cascade
  end

  def down
    drop_table :users, force: :cascade
  end
end
