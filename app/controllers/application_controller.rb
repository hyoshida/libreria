class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    return authenticate_user! unless current_user
    return if current_user.admin?
    redirect_to root_path, alert: t(:access_denied)
  end

  def flash_message_for(resource, key)
    resource_name = resource.class.model_name.human
    resource_name += " \"#{resource.name}\"" if resource.respond_to?(:name) && resource.name.present?
    t(key, resource: resource_name)
  end
end
