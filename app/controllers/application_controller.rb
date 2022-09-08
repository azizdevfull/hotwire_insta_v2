class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:avatar, :username, :email, :password, :password_confirmation, :bio, :website]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end




  #   before_action :configure_permitted_parameters, if: :devise_controller?

#   protected

#     def configure_permitted_parameters
#       devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar, :website, :bio])
#       devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
#       devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
#     end
# end
end