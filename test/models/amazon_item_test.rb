require 'test_helper'

class AmazonItemTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:asin)
  should validate_presence_of(:asin)
  should validate_presence_of(:item)
  should validate_length_of(:asin).is_at_most(255)
end
