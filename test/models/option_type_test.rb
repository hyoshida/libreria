require 'test_helper'

class OptionTypeTest < ActiveSupport::TestCase
  subject { build(:option_type, :with_namespace) }

  should have_many(:option_values).dependent(:destroy)

  should validate_uniqueness_of(:name).scoped_to(:namespace_id)
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)
end
