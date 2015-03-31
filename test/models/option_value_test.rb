require 'test_helper'

class OptionValueTest < ActiveSupport::TestCase
  should belong_to(:option_type)
end
