class Member < ActiveRecord::Base
  module Requestable
    extend ActiveSupport::Concern

    included do
      validates :request_token, uniqueness: { allow_nil: true }
    end

    def generate_request_token
      self.request_token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(request_token: random_token)
      end
    end
  end
end
