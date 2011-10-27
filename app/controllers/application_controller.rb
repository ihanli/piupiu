class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def render_optional_error_file(status_code)
    if status_code == 500
      render :template => "pages/500", :status => 500, :layout => "error"
    elsif status_code == 404
      render :template => "pages/404", :status => 404, :layout => "error"
    end
  end
end
