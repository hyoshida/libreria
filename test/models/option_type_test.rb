require 'test_helper'

class OptionTypeTest < ActiveSupport::TestCase
  should have_many(:option_values).dependent(:destroy)

  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)
end
