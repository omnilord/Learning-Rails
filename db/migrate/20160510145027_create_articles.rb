class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.timestamps
      t.string :title
      t.text :body
      t.string :tags, array: true, default: []
    end
  end
end
