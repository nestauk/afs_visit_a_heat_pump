class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :accepted_terms_at
    ])
  end

  def after_sign_up_path_for(user)
    path_if_registration_incomplete(user.host)
  end

  def after_sign_in_path_for(user)
    path_if_registration_incomplete(user.host)
  end

  def path_if_registration_incomplete(host)
    return new_host_path if host.nil?
    host_home_path
  end
end
