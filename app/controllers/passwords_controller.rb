class PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, :location => after_sending_reset_password_instructions_path_for(resource_name)
    else
      respond_with_navigational(resource){ render_with_scope :new }
    end
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    page_path("check_mail")
  end
end