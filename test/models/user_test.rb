require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_one(:namespace)
  should have_many(:members)
  should have_many(:organizations).through(:members)

  should accept_nested_attributes_for(:namespace)

  should validate_presence_of(:namespace)
  should validate_presence_of(:role)
  should validate_length_of(:role).is_at_most(255)
end
