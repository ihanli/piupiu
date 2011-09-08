class PostsController < ApplicationController
  before_filter :authenticate_user!

  def index
    _params = params
    _params.reject! { |k,v| _params[k] != "descendent.count" || _params[k] != "created_at" }
    redirect_to page_path("404"), :status => 404 and return unless @trees = Post.roots
    redirect_to page_path("500"), :status => 500 and return unless _params.has_key?("sort_by") && _params.has_key?("order")
    Post.sort_by_criteria(@trees, _params[:sort_by], _params[:order])
  end

  def show
    respond_to do |format|
      format.html
      format.json{
        redirect_to page_path("404"), :status => 404 and return unless @tree = Post.roots.find_by_id(params[:id])
        @post = Post.new
        render :json => @tree.to_node.to_json
      }
    end
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new(:user => current_user, :image => params[:post][:image])
    redirect_to page_path("500"), :status => 500 and return unless post.set_ancestor(params[:post][:ancestry]) if params[:post][:ancestry]
    post.save ? redirect_to(post_path(post.root.id)) : redirect_to(page_path("500"), :status => 500) and return
  end

  def destroy
    redirect_to page_path("404"), :status => 404 and return unless post = Post.find_by_id(params[:id])
    post.replace_image_with("#{Rails.root.to_s}/public/images/grabstein-19.png")
    post.save ? redirect_to(post_path(post.root.id)) : redirect_to(page_path("500"), :status => 500) and return
  end

  def comment
    redirect_to page_path("404"), :status => 404 and return unless @node = Post.find_by_id(params[:post_id])
    @post = Post.new
    render :partial => "comment"
  end

  def download
    redirect_to page_path("404"), :status => 404 and return unless file = Post.find_by_id(params[:post_id])
    send_file "#{Rails.root.to_s}/public#{file.image.url(:original, false)}"
  end
end
