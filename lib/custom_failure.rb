class CustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  def redirect
    message = warden.message || warden_options[:message]

    if message == :timeout
      redirect_to page_path("timeout")
    else 
      super
    end 
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end