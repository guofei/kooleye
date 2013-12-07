class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :name, :username, :email, :password, :password_confirmation)
    end
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (!(request.fullpath =~ /\/users/) &&
        !(request.fullpath =~ /\/admin/) &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if current_admin_user.blank?
      session[:previous_url] || root_path
    else
      admin_dashboard_path
    end
  end
end
