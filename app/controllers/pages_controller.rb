class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :about, :careers]

  # Stub controller for static pages without any dynamic content
  def badroute
    flash[:danger] = "Could not load that page."
    redirect_to root_path
  end
end
