class RegistrationsController < Devise::RegistrationsController
  def new
    @countries_array = Country.all.map { |country| [country.fullname, country.abbreviation] }
    redirect_to page_path("500") and return unless @countries_array.count > 0
    super
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    page_path("check_mail")
  end
end