class SessionsController < ApplicationController

  # @TODO: Back sessions with JSON in the database, NOT Base64-encoded
  #        encrypted cookies

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = 'Welcome to World of Blag!'
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'Invalid credentials.  Please try again.'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Thank you for visiting!  Comback soon!'
    redirect_to root_path
  end
end
