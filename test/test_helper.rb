ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Devise::TestHelpers

  def sign_in_user
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in User.first || create(:user)
  end
end
