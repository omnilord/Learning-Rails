class UsersController < AuthAppController
  def portfolio
    @user = current_user

    respond_to do |format|
      if @user.nil?
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      else
        format.html { render :portfolio }
        format.json {
          render json: {
            status: :ok,
            data: {
              portfolio: @user.portfolio_summary,
              stocks: UserStock.where('user_id = ?', @user.id).map do |tracking|
                { stock: tracking.stock, track: tracking }
              end
            }
          }
        }
      end
    end
  end

  def friends
    @user = current_user

    respond_to do |format|
      if @user.nil?
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      else
        format.html { render :friends }
        format.json {
          render json: {
            status: :ok,
            data: {
              friends: Friendship.where('user_id = ?', @user.id).map do |friendship|
                friend = friendship.friend
                {
                  user_id: friend.id,
                  fullname: friend.fullname,
                  email: friend.email,
                  portfolio: friend.portfolio_summary
                }
              end
            }
          }
        }
      end
    end
  end
end
