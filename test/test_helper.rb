ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::TestHelpers

  def sign_in_user(user = nil)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user || create(:user)
  end
end
