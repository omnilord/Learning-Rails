class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] { |c| c.require_user(user_path(@user)) }
  before_action :allow_edit, only: [:edit, :update]
  before_action :allow_destroy, only: [:destroy]

  helper_method :edit_allowed?, :destroy_allowed?

  def index
    @users = User.order(:username).paginate(page: params[:page], per_page: 8)
  end

  def show
    @user_articles = @user.articles.order(updated_at: :desc)
                          .paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.'
        session[:user_id] = @user.id
        format.html { redirect_to @user, success: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to @user, success:  'User was successfully updated.'}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'User was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to users_url, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def edit_allowed?(user_id = @user.id)
    logged_in? && (user_id == current_user.id || current_user.privilege >= User::PRIV_SR_MOD)
  end

  def allow_edit
    redirect_to user_path(@user) unless edit_allowed?
  end

  def destroy_allowed?(user_id = @user.id)
    if user_id == 1
      flash[:danger] = "Root administrator cannot be destroyed.  All glory to Admin!"
      false
    else
      logged_in? && (user_id == current_user.id || current_user.privilege == User::PRIV_ADMIN)
    end
  end

  def allow_destroy
    redirect_to user_path(@user) unless destroy_allowed?
  end
end
