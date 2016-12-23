class User::DeviseAuthyController < Devise::DeviseAuthyController

  protected

  def after_authy_disabled_path_for(resource)
    edit_user_registration_path(current_user)
  end
end
