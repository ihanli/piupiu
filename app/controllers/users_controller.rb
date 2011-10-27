class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @posts = Post.roots.find_all_by_user_id(current_user.id)
    @comments = Post.comments.find_all_by_user_id(current_user.id)
  end
  
  def show
    @user = User.find_by_id(params[:id])
    @posts = Post.roots.find_all_by_user_id(@user.id)
    @comments = Post.comments.find_all_by_user_id(@user.id)
    
    render :action => :index
  end
end
