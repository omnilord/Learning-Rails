class StocksController < ApplicationController
  def search
    if params[:search]
      @stock = Stock.fetch_stock(params[:search])
      if @stock
        render_json do
          {
            logged_in: user_signed_in?,
            stock: @stock,
            track: user_signed_in? ?
                    # REVIEW: Not sure which of these is considered "better":
                    #         Using the second because it looks cleaner.
                    # @stock.user_stocks.where('user_id = ?', current_user.id).first : nil
                    UserStock.where(user: current_user, stock: @stock).first : nil
          }
        end
      else
        render_status :not_found
      end
    else
      render_status :bad_request
    end
  end

  def index
    @stocks = Stock.order(ticker: :asc).paginate(page: params[:page], per_page: 20)
    if @stocks
      render_json { @stocks }
    else
      render_status :not_found
    end
  end
end
