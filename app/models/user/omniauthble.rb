class User < ActiveRecord::Base
  module Omniauthble
    extend ActiveSupport::Concern

    module ClassMethods
      def from_omniauth(auth)
        uid_column = "#{auth.provider}_uid"
        user = where(uid_column => auth.uid).first
        user ||= where(email: auth.info.email).first_or_initialize
        user.attributes = {
          uid_column => auth.uid,
          name: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          namespace_attributes: { path: auth.info.email.split('@').first }
        }
        user
      end

      # This method called by new oauth user
      def new_with_session(params, session)
        super.tap do |user|
          auth = find_provider_and_auth_from_session(session)
          if auth
            user.send("#{auth['provider']}_uid=", auth['uid'])
            user.name = auth['info']['name'] if user.name.blank?
            user.email = auth['info']['email'] if user.email.blank?
            user.build_namespace(path: auth['info']['email'].split('@').first) unless user.namespace
          end
        end
      end

      private

      def find_provider_and_auth_from_session(session)
        omniauth_providers.each do |provider|
          auth = session["devise.#{provider}_data"]
          return auth if auth
        end
        nil
      end
    end
  end
end
