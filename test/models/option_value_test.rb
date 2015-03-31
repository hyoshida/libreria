require 'test_helper'

class OptionValueTest < ActiveSupport::TestCase
  should belong_to(:option_type)

  should validate_uniqueness_of(:name).scoped_to(:option_type_id)
  should validate_presence_of(:option_type)
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)
end
