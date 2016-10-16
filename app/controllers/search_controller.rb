class SearchController < ApplicationController

  def search
    unless params[:q].present?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", layout: false, status: 400 }
        format.json { render json: { statis: 400, error: 'Bad request, no search term provided.' } }
      end
      return
    end

    @term = params[:q]
    @search = Search.query(@term).paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html { render :search }
      format.json { render json: @search }
    end
  end
end
