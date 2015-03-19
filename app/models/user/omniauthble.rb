class User < ActiveRecord::Base
  module Omniauthble
    extend ActiveSupport::Concern

    module ClassMethods
      def from_omniauth(auth)
        user = find_by_auth(auth)
        user ||= find_by(email: auth['info']['email'])
        user ||= new
        user.attributes = attributes_from_auth(auth)
        user.password = Devise.friendly_token[0, 20] if user.new_record?
        user
      end

      # This method called by new oauth user
      def new_with_session(params, session)
        super.tap do |user|
          auth = find_provider_and_auth_from_session(session)
          user.attributes = attributes_from_auth(auth) if auth
        end
      end

      private

      def find_by_auth(auth)
        find_by("#{auth['provider']}_uid" => auth['uid']) if auth
      end

      def find_provider_and_auth_from_session(session)
        omniauth_providers.each do |provider|
          auth = session["devise.#{provider}_data"]
          return auth if auth
        end
        nil
      end

      def username_from_email(email)
        return if email.blank?
        email.split('@').first
      end

      def attributes_from_auth(auth)
        {
          :"#{auth['provider']}_uid" => auth['uid'],
          name: auth['info']['name'],
          email: auth['info']['email'],
          namespace_attributes: { path: username_from_email(auth['info']['email']) }
        }
      end
    end
  end
end
