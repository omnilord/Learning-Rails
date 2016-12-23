class User::RegistrationsController < Devise::RegistrationsController
  before_filter :config_permitted_params

  protected

  def config_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :occupation, :location])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :occupation, :location])
  end
end
