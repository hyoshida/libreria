require 'test_helper'

class BooksOptionValueTest < ActiveSupport::TestCase
  should belong_to(:book)
  should belong_to(:option_value)
end
