class StocksController < ApplicationController
  def search
    if params[:search]
      @stock = Stock.fetch_stock(params[:search])
      if @stock
        @owned = user_signed_in? ?
                   @stock.user_stocks.where('user_id = ?', current_user.id).first : nil
        render json: { status: :ok, data: { stock: @stock, track: @owned } }
      else
        render status: :not_found, nothing: true
      end
    else
      render partial: 'search'
    end
  end

  def index
    @stocks = Stock.order(ticker: :asc).paginate(page: params[:page], per_page: 20)
    if @stocks
      render json: @stocks
    else
      render status: :not_found, nothing: true
    end
  end
end
