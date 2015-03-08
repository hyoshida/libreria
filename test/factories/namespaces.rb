FactoryGirl.define do
  factory :namespace do
    sequence(:path) { |n| format('example%d', n) }

    trait :with_organization do
      association :ownerable, factory: :organization
    end

    trait :with_user do
      association :ownerable, factory: :user
    end
  end
end
