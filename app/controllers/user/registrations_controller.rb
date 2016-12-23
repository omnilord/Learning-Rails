class User::RegistrationsController < Devise::RegistrationsController
  before_filter :config_permitted_params

  protected

  def after_sign_up_path_for(resource)
    if params['user']['mfa'] == '1'
      user_enable_authy_path
    else
      after_sign_in_path_for(resource)
    end
  end

  def config_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :occupation, :location])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :occupation, :location])
  end
end
