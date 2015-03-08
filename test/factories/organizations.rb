FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| format('Example #%d', n) }
    sequence(:namespace_attributes) { |n| { path: format('organization-%d', n) } }
    members_attributes { [user: create(:user), role: :owner] }
  end
end
