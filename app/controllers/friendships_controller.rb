class FriendshipsController < AuthAppController
  def index
    respond_to do |format|
      format.html { render :friends }
      format.json do
        render_json do
          {
            friends: current_user.friends.map do |friend|
              friend.friendship_summary(current_user)
            end
          }
        end
      end
    end
  end

  def show
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

  def create
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

  def destroy
    # HACK: using inline rescue
    @friend = User.find(params[:id]) rescue nil
    if @friend
      friendship = Friendship.where(user_id: current_user.id, friend_id: @friend.id)
      current_user.friendships.delete(friendship)
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
end
