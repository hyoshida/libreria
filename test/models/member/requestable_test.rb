class DummyMember < ActiveRecord::Base
  include Member::Requestable
end

class Member::RequestableTest < ActiveSupport::TestCase
  setup do
    create_dummy_table
    @member = DummyMember.new
    @member.generate_request_token
  end

  teardown do
    drop_dummy_table
  end

  subject { @member }

  should belong_to(:request_acceptor).class_name(User.name)

  should validate_uniqueness_of(:request_token).allow_nil

  private

  def create_dummy_table
    ActiveRecord::Migration.new.instance_eval do
      self.verbose = false
      create_table :dummy_members do |t|
        t.string :request_token, index: { unique: true }
        t.references :request_acceptor
        t.timestamps null: false
      end
    end
  end

  def drop_dummy_table
    ActiveRecord::Migration.new.instance_eval do
      self.verbose = false
      drop_table :dummy_members
    end
  end
end
