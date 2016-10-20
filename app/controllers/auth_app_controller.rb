class AuthAppController < ApplicationController
  before_action :authenticate_user!
end
