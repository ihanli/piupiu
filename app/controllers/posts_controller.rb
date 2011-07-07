class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(params[:post])
    post.user = current_user
    
    if post.save
      redirect_to user_root_path
    else
      redirect_to new_user_post_path(current_user.id)
    end
  end
end
