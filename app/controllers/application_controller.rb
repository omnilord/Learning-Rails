class ApplicationController < ActionController::Base
  attr_reader :current_user, :logged_in

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  before_action :current_user
  before_action :redirect_banned_user

  def current_user
    @authenticated_user ||= (session[:user_id] ? User.find(session[:user_id]) : nil)
  end

  def redirect_banned_user
    if @authenticated_user &&
        @authenticated_user.privilege == User::PRIV_NONE &&
        request.path != '/banned'
      redirect_to '/banned'
    end
  end

  def logged_in?
    @logged_in = !!current_user
  end

  def require_user(target = root_path)
    if !logged_in?
      flash[:danger] = 'You must be logged in to perform that action.'
      redirect_to target
    end
  end
end
