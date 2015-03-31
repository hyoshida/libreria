require 'test_helper'

class BooksOptionValueTest < ActiveSupport::TestCase
  should belong_to(:book)
  should belong_to(:option_value)

  should validate_uniqueness_of(:option_value_id).scoped_to(:book_id)
  should validate_presence_of(:book)
  should validate_presence_of(:option_value)
end
