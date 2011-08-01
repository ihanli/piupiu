class RegistrationsController < Devise::RegistrationsController
  def new
    @countries_array = Country.all.map { |country| [country.fullname, country.abbreviation] }
    redirect_to page_path("500") and return unless @countries_array.count > 0
    super
  end
  
  def edit
    if params[:page] == "pw"
      render "users/registrations/password"
    elsif params[:page] == "avatar"
      render "users/registrations/avatar"
    else
      redirect_to page_path("404") and return
    end
  end
  
  def update
    avatar_changed = true if params[resource_name][:avatar]
    
    if avatar_changed
      flag = resource.update_attributes(params[resource_name])
    else
      flag = resource.update_with_password(params[resource_name])
    end
    
    if flag
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      redirect_to page_path("500") and return
    end
  end
  
  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_delete_account_path_for(resource_name) }
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    page_path("check_mail")
  end
  
  def after_delete_account_path_for(resource)
    page_path("profile_deleted")
  end
end