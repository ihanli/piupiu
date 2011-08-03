class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @trees = Post.roots
    redirect_to page_path("404") and return unless @trees.count > 0
    
    unless params[:sort_by] == "node_count"
      if params[:order] == "DESC"
        @trees.sort! { |a,b| b.created_at <=> a.created_at }
      else params[:order] == "ASC"
        @trees.sort! { |a,b| a.created_at <=> b.created_at }
      end
    else 
      if params[:order] == "ASC"
        @trees.sort! { |a,b| a.descendants.count <=> b.descendants.count }
      else
        @trees.sort! { |a,b| b.descendants.count <=> a.descendants.count }
      end
    end
  end
  
  def show
    @tree = Post.roots.find_by_id(params[:id])
    redirect_to page_path("404") and return unless @tree
    @post = Post.new
    
    respond_to do |format|
      format.html
      format.json { render :json => @tree.to_node.to_json }
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(:user => current_user, :image => params[:post][:image])
    
    if params[:post][:ancestry]
      parent = Post.find_by_id(params[:post][:ancestry]) 
      redirect_to page_path("500") and return unless parent
      
      unless parent.is_root?
        post.ancestry = "#{parent.ancestry}/#{parent.id}"
      else
        post.ancestry = parent.id.to_s
      end
    end
    
    if post.save
      redirect_to post_path(post.root.id)
    else
      redirect_to page_path("500") and return
    end
  end
  
  def destroy
    post = Post.find_by_id(params[:id])
    post.replace_image_with("#{Rails.root.to_s}/public/images/grabstein-19.png")
    
    if post.save
      redirect_to post_path(post.root.id)
    else
      redirect_to page_path("500") and return
    end
  end
  
  def comment
    @node = Post.find_by_id(params[:post_id])
    redirect_to page_path("404") and return unless @node
    @post = Post.new

    respond_to do |format|
      format.html { render :partial => "comment" }
    end
  end
  
  def download
    file = Post.find_by_id(params[:post_id])
    redirect_to page_path("404") and return unless file
    send_file "#{Rails.root.to_s}/public#{file.image.url(:original, false)}"
  end
end
