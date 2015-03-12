require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  subject { build(:loan) }

  should belong_to(:book)
  should belong_to(:user)

  should validate_uniqueness_of(:book_id).scoped_to([:user_id, :returned_at])
  should validate_presence_of(:book)
  should validate_presence_of(:user)
end
