class PagesController < ApplicationController
  def index
  end

  def about
  end

  def careers
  end

  def banned
    if !@authenticated_user || @authenticated_user.privilege != User::PRIV_NONE
      redirect_to root_path
    end
  end
end
