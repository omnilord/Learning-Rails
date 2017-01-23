class UsersController < AuthAppController
  before_action :set_user

  def portfolio
    respond_to do |format|
      format.html { render :portfolio }
      format.json do
        render_json do
          {
            logged_in: user_signed_in?,
            portfolio: @user.portfolio_summary,
            stocks: @user.user_stocks.map do |tracking|
              { stock: tracking.stock, track: tracking }
            end
          }
        end
      end
    end
  end

  def search
    @users = User.search(params[:search])
    if @users
      render_json do
        {
          users: @users.map do |user|
            user.friendship_summary(@user)
          end
        }
      end
    else
      render_status :not_found
    end
  end

  private

  def set_user
    @user = current_user
  end
end
