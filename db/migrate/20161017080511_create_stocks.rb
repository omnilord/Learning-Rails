class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.text :ticker
      t.text :name
      t.decimal :last_price

      t.timestamps null: false
    end
  end
end
