class UsersController < AuthAppController
  def portfolio
    @user = current_user

    respond_to do |format|
      if @user.nil?
        format.html { redirect_to root_path }
        format.json { render json: { status: :unauthorized } }
      else
        @stocks = UserStock.where('user_id = ?', @user.id).map do |tracking|
          { stock: tracking.stock, track: tracking }
        end
        format.html { render :portfolio }
        format.json { render json: {
            status: :ok,
            data: @stocks
          }
        }
      end
    end
  end
end
