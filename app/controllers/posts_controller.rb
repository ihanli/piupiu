class PostsController < ApplicationController
  before_filter :authenticate_user!

  def index
    _params = params
    _params.reject! { |k,v| _params[k] != "descendants.count" && _params[k] != "created_at" && _params[k] != "DESC" && _params[k] != "ASC" }
    @trees = Post.roots
    Post.sort_by_criteria(@trees, _params[:sort_by], _params[:order]) if _params.has_key?("sort_by") && _params.has_key?("order")
  end

  def show
    @tree = Post.roots.find_by_id params[:id]
    
    respond_to do |format|
      format.html{ @post = Post.new }
      format.json{ render :json => @tree.to_node.to_json }
    end
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new :user => current_user

    if params[:post]
      post.image = params[:post][:image]
      post.set_ancestor params[:post][:ancestry]
    else
      tmp_dir_path = "#{Rails.root}/public/system/#{current_user.id}/tmp"
  
      if File.directory? tmp_dir_path
        Dir.foreach(tmp_dir_path) do |f|
          next if f == "." || f == ".."
          post.image = File.open "#{tmp_dir_path}/#{f}"
          fn = File.join tmp_dir_path, f
          File.delete fn
        end
      end
    end

    if post.save
      PostMailer.new_comment(post, post.root.user.email).deliver
      PostMailer.new_comment(post, post.parent.user.email).deliver if post.parent
      redirect_to post_path(post.root.id)
    end
  end

  def destroy
    post = Post.find_by_id params[:id]

    post.is_childless? ? post.destroy : post.update_attribute(:deleted, true)
    post.is_root? ? redirect_to(posts_path) : redirect_to(post_path(post.root.id))
  end

  def comment
    @node = Post.find_by_id params[:post_id]
    @post = Post.new
    render :partial => "comment"
  end

  def download
    file = Post.find_by_id params[:post_id]
    send_file "#{Rails.root.to_s}/public#{file.image.url(:original, false)}"
  end
end
