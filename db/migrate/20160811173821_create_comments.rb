class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.text :body
    end
  end
end
