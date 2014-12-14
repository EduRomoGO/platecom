class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end

  def after_sign_in_path_for(resource_or_scope)
    "/users/#{current_user.id}/issues"
	end

	def after_sign_out_path_for(resource_or_scope)
	  URI.parse(request.referer).path if request.referer
	end

end
