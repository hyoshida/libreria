require 'test_helper'

class BookTest < ActiveSupport::TestCase
  subject { build(:book, :with_namespace) }

  should belong_to(:namespace)
  should belong_to(:amazon_item)
  should have_many(:wishes).dependent(:destroy)
  should have_many(:loans).dependent(:destroy)
  should have_many(:books_option_value).dependent(:destroy)
  should have_many(:option_values).through(:books_option_value)

  should validate_uniqueness_of(:amazon_item_id).scoped_to(:namespace_id)
  should validate_presence_of(:namespace)
  should validate_presence_of(:amazon_item)
  should validate_length_of(:state).is_at_most(255)
  should validate_length_of(:location_name).is_at_most(255)
end
