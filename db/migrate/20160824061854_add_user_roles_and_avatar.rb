class AddUserRolesAndAvatar < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :text, null: true

    # Privilege, the higher, the fewer
    # 0 = You've been banned
    # 1 = regular users
    # 2 = moderators
    # 3 = managers
    # 4 = admins
    # 5 = super user, there can be only one.
    add_column :users, :privilege, :integer, default: 1
  end
end
