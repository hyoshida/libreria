require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  subject { create(:organization) }

  should have_one(:namespace).dependent(:destroy)
  should have_many(:members).dependent(:destroy)
  should have_many(:users).through(:members)

  should accept_nested_attributes_for(:namespace)
  should accept_nested_attributes_for(:members)

  should validate_presence_of(:namespace)
  should validate_presence_of(:members)
  should validate_presence_of(:name)
  should validate_presence_of(:published)
  should validate_length_of(:name).is_at_most(255)

  test 'create with email of owner' do
    user = build(:user)
    organization = build(:organization, members_attributes: [user: user, role: :owner, activated: true])
    organization.save!
    assert organization.email == user.email
  end
end
