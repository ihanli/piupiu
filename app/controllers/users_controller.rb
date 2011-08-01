class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @posts = Post.roots.find_all_by_user_id(current_user.id)
  end
end
