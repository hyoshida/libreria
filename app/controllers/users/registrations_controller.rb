class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << permitted_attributes
  end

  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << permitted_attributes
  end

  def permitted_attributes
    [ :name, namespace_attributes: [:id, :path, option_types: [:id, :_destroy, :name]] ]
  end
end
