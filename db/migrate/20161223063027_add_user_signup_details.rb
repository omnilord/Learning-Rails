class AddUserSignupDetails < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :occupation, :text
    add_column :users, :location, :text
  end
end
