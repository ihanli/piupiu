class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @tree = Post.find_by_id(params[:id])
    @post = Post.new
    
    respond_to do |format|
      format.html
      format.json { render :json => @tree.root.to_node.to_json }
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(:user => current_user, :image => params[:post][:image])
    
    if params[:post][:ancestry]
      parent = Post.find_by_id(params[:post][:ancestry]) 
      
      unless parent.is_root?
        post.ancestry = "#{parent.ancestry}/#{parent.id}"
      else
        post.ancestry = parent.id.to_s
      end
    end
    
    if post.save
      redirect_to post_path(post.root.id)
    else
      redirect_to new_post_path
    end
  end
  
  def comment
    @node = Post.find_by_id(params[:post_id])
    @post = Post.new

    respond_to do |format|
      format.html { render :partial => "comment" }
    end
  end
  
  def download
    file = Post.find_by_id(params[:post_id])
    send_file "#{Rails.root.to_s}/public#{file.image.url(:original, false)}"
  end
end
