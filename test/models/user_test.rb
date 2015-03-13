require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_one(:namespace).dependent(:destroy)
  should have_many(:members).dependent(:destroy)
  should have_many(:organizations).through(:members)
  should have_many(:wishes).dependent(:destroy)
  should have_many(:loans).dependent(:destroy)

  should accept_nested_attributes_for(:namespace)

  should validate_presence_of(:namespace)
  should validate_presence_of(:role)
  should validate_length_of(:role).is_at_most(255)
end
