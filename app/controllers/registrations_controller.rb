class RegistrationsController < Devise::RegistrationsController
  before_filter :get_countries_array, :only => [:new, :create]
  
  def create
    @image_data = params[:user][:image_data]
    @country = params[:user][:country]
    super
  end

  def edit
    if params[:page] == "pw"
      render "users/registrations/password"
    elsif params[:page] == "avatar"
      render "users/registrations/avatar"
    end
  end

  def update
    params[resource_name][:reset_password_token] = nil if params[resource_name][:reset_password_token]
    
    if params[resource_name][:image_data] ? resource.update_attributes(params[resource_name]) : resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords resource
      render(:file => "#{Rails.root}/public/500.html", :status => 500) and return
    end
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_delete_account_path_for(resource_name) }
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    page_path "check_mail"
  end

  def after_delete_account_path_for(resource)
    page_path "profile_deleted"
  end

  def get_countries_array
    @countries_array = Country.all.map { |country| [country.fullname, country.abbreviation] }
    render(:file => "#{Rails.root}/public/500.html", :status => 500) and return unless @countries_array.count > 0
  end
end