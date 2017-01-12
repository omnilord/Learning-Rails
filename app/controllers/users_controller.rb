class UsersController < AuthAppController
  before_action :set_user #, only: [:portfolio, :friends, :friend]

  def portfolio
    respond_to do |format|
      if @user.nil?
        flash[:danger] = 'Please sign in first.';
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      else
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
  end

  def friends
    respond_to do |format|
      if @user.nil?
        flash[:danger] = 'Please sign in first.';
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      else
        format.html { render :friends }
        format.json do
          render_json do
            {
              friends: @user.friends.map do |friend|
                {
                  user_id: friend.id,
                  fullname: friend.fullname,
                  email: friend.email,
                  portfolio: friend.portfolio_summary
                }
              end
            }
          end
        end
      end
    end
  end

  def friend
    @friend =
      begin
        User.find(params[:id])
      rescue
        nil
      end
    respond_to do |format|
      if @user.nil?
        flash[:danger] = 'Please sign in first.';
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      elsif @friend.nil?
        flash[:danger] = 'No user found.';
        format.html { redirect_to root_path }
        format.json { render json: { status: :not_found } }
      else
        format.html { render :friend }
        format.json do
          render_json do
            {
              friend: {
                fullname: @friend.fullname,
                email: @friend.email
              },
              portfolio: @friend.portfolio_summary,
              stocks: @friend.user_stocks.map do |tracking|
                { stock: tracking.stock, track: tracking }
              end
            }
          end
        end
      end
    end
  end

  def search
    #code
  end

  def add_friend
    #code
  end

  def remove_friend
    #code
  end

  private

  def set_user
    @user = current_user
  end
end
