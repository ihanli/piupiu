class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @user = User.find_by_id(current_user.id)
  end
  
  def show
    @user = User.find_by_id(params[:id])
  end
end
