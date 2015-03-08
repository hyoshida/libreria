class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    return authenticate_admin_user! unless current_user
    return if current_user.admin?
    redirect_to root_path, alert: I18n.t('devise.failure.unauthenticated')
  end
end
