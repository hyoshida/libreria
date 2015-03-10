require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  should have_one(:namespace)
  should have_many(:members)
  should have_many(:_owner_members).class_name(Member.name).conditions(role: 'owner')
  should have_many(:owners).through(:_owner_members).source(:user)

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
