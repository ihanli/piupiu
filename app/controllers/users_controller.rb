class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :empty_or_create_directory, :only => :attachement_upload

  def index
    @user = current_user
    @posts = Post.roots.find_all_by_user_id current_user.id
    @comments = Post.comments.find_all_by_user_id current_user.id
  end
  
  def show
    @user = User.find_by_id params[:id]
    @posts = Post.roots.find_all_by_user_id @user.id
    @comments = Post.comments.find_all_by_user_id @user.id
    
    render :action => :index
  end

  def attachement_upload
    tmp_file = "#{Rails.root}/public/system/#{current_user.id}/tmp/#{params[:post][:image].original_filename}"
    FileUtils.mv params[:post][:image].tempfile.path, tmp_file
    File.chmod 0644, tmp_file
    render :json => {"filepath" => "/system/#{current_user.id}/tmp/#{params[:post][:image].original_filename}"}
  end

  private

  def empty_or_create_directory
    tmp_dir_path = "#{Rails.root}/public/system/#{current_user.id}/tmp"

    if File.directory? tmp_dir_path
      Dir.foreach(tmp_dir_path) {|f| fn = File.join(tmp_dir_path, f); File.delete(fn) if f != '.' && f != '..'}
    else
      Dir.mkdir tmp_dir_path, 0755
    end
  end
end
