require 'test_helper'

class NamespaceTest < ActiveSupport::TestCase
  subject { build(:namespace, :with_organization) }

  should belong_to(:ownerable)

  should validate_uniqueness_of(:path)
  should validate_presence_of(:path)
  should validate_length_of(:path).is_at_most(255)

  should allow_value('test').for(:path)
  should_not allow_value('foo/bar').for(:path)
  should_not allow_value('日本語').for(:path)
end
