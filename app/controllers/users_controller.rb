class UsersController < AuthAppController
  before_action :set_user #, only: [:portfolio, :friends, :friend]

  def portfolio
    respond_to do |format|
      format.html { render :portfolio }
      format.json do
        render_json do
          {
            portfolio: @user.portfolio_summary,
            stocks: @user.user_stocks.map do |tracking|
              { stock: tracking.stock, track: tracking }
            end
          }
        end
      end
    end
  end

  def friends
    respond_to do |format|
      format.html { render :friends }
      format.json do
        render_json do
          {
            friends: @user.friends.map do |friend|
              friend.friendship_summary(current_user)
            end
          }
        end
      end
    end
  end

  def friend
    # HACK: using inline rescue
    @friend = User.find(params[:id]) rescue nil

    respond_to do |format|
      if @friend.nil?
        flash[:danger] = 'No user found.';
        format.html { redirect_to root_path }
        format.json { render json: { status: :not_found } }
      else
        format.html { render :friend }
        format.json do
          render_json do
            @friend.friendship_summary(current_user)
          end
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
            user.friendship_summary(current_user)
          end
        }
      end
    else
      render_status :not_found
    end
  end

  def add_friend
    # HACK: using inline rescue
    @friend = User.find(params[:id]) rescue nil
    if @friend
      current_user.friends << @friend
      current_user.save

      render_json do
        @friend.friendship_summary(current_user)
      end
    else
      render_status :not_found
    end
  end

  def remove_friend
    # HACK: using inline rescue
    @friend = User.find(params[:id]) rescue nil
    if @friend
      current_user.friendships.delete(Friendship.where(user_id: current_user.id, friend_id: @friend.id))
      current_user.save

      @friend.reload
      current_user.reload

      render_json do
        @friend.friendship_summary(current_user)
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
