class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @posts = Post.find_all_by_user_id_and_ancestry(current_user.id, nil)
  end
end
