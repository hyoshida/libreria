module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        # To use `new_with_session` method.
        session['devise.google_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end
end
