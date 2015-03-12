require 'test_helper'

class WishTest < ActiveSupport::TestCase
  subject { build(:wish) }

  should belong_to(:book)
  should belong_to(:user)

  should validate_uniqueness_of(:book_id).scoped_to(:user_id)
  should validate_presence_of(:book)
  should validate_presence_of(:user)
end
