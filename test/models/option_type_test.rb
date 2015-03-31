require 'test_helper'

class OptionTypeTest < ActiveSupport::TestCase
  should have_many(:option_values).dependent(:destroy)
end
