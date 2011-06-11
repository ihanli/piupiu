class PagesController < ApplicationController
  def index
    redirect_to user_path(current_user.id) if user_signed_in?
  end
  
  def impressum
  end
  
  def wtf
  end
end