class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    posts_path :order => "DESC", :sort_by => "created_at"
  end
end