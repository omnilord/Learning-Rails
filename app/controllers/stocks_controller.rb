class StocksController < ApplicationController
  def search
    if params[:stock]
      @stock = Stock.fetch_stock(params[:stock])
      if @stock
        render json: @stock
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
