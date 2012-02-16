class PostsController < ApplicationController
  before_filter :authenticate_user!

  def index
    _params = params
    _params.reject! { |k,v| _params[k] != "descendants.count" && _params[k] != "created_at" && _params[k] != "DESC" && _params[k] != "ASC" }
    render_optional_error_file(404) and return unless @trees = Post.roots
    Post.sort_by_criteria(@trees, _params[:sort_by], _params[:order]) if _params.has_key?("sort_by") && _params.has_key?("order")
  end

  def show
    render_optional_error_file(404) and return unless @tree = Post.roots.find_by_id(params[:id])
    
    respond_to do |format|
      format.html{ @post = Post.new }
      format.json{ render :json => @tree.to_node.to_json }
    end
  end

  def new
    @post = Post.new
  end

  def create
    render_optional_error_file(500) and return unless params[:post]
    post = Post.new(:user => current_user, :image => params[:post][:image])
    render_optional_error_file(500) and return unless post.set_ancestor(params[:post][:ancestry]) if params[:post][:ancestry]
    post.save ? redirect_to(post_path(post.root.id)) : render_optional_error_file(418) and return
  end

  def destroy
    render_optional_error_file(404) and return unless post = Post.find_by_id(params[:id])

    if post.is_childless?
      post.destroy
      redirect_to posts_path
    else
      post.update_attribute(:deleted, true) ? redirect_to(post_path(post.root.id)) : (render_optional_error_file(418) and return)
    end
  end

  def comment
    render_optional_error_file(404) and return unless @node = Post.find_by_id(params[:post_id])
    @post = Post.new
    render :partial => "comment"
  end

  def download
    render_optional_error_file(404) and return unless file = Post.find_by_id(params[:post_id])
    send_file "#{Rails.root.to_s}/public#{file.image.url(:original, false)}"
  end
end
