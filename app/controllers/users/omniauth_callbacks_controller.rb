module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted? || @user.save
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        # To use `new_with_session` method.
        session['devise.omniauth.auth'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end
end
