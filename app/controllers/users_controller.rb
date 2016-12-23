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
          value = 0
          shares = 0
          @stocks = UserStock.where('user_id = ?', @user.id).map do |tracking|
            value += tracking.owned * tracking.stock.last_price
            shares += tracking.owned
            { stock: tracking.stock, track: tracking }
          end
          render json: {
            status: :ok,
            data: {
              portfolio: {
                shares: shares,
                value: value
              },
              stocks: @stocks
            }
          }
        }
      end
    end
  end

  def friends
    #code
  end
end
