require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  setup do
    @organization = build_stubbed(:organization)
    @user = build_stubbed(:user)
  end

  subject { build(:member, organization: @organization, user: @user) }

  should belong_to(:organization)
  should belong_to(:user)

  should validate_uniqueness_of(:organization_id).scoped_to(:user_id)
  should validate_presence_of(:user)
  should validate_presence_of(:role)
  should validate_length_of(:role).is_at_most(255)
end
