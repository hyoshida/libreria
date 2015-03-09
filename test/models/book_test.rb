require 'test_helper'

class BookTest < ActiveSupport::TestCase
  setup do
    @namespace = build_stubbed(:namespace, :with_user)
  end

  subject { build(:book, namespace: @namespace) }

  should belong_to(:namespace)
  should belong_to(:amazon_item)

  should validate_uniqueness_of(:amazon_item_id).scoped_to(:namespace_id)
  should validate_presence_of(:namespace)
  should validate_presence_of(:amazon_item)
  should validate_length_of(:state).is_at_most(255)
  should validate_length_of(:location_name).is_at_most(255)
end
