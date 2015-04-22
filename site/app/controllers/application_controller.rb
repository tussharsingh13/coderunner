class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation,:college,:about_me)
    end
  end
  
   def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u| 
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation,:college,:current_password,:about_me) 
    end
  end
end
