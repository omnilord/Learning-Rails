class PagesController < ApplicationController
  # Stub controller for static pages without any dynamic content
  def badroute
    flash[:danger] = "Could not load that page."
    redirect_to root_path
  end
end
