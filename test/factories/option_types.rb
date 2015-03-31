FactoryGirl.define do
  factory :option_type do
    sequence(:name) { |n| "OptionType ##{n}" }

    trait :with_namespace do
      namespace { build_stubbed(:namespace, :with_user) }
    end
  end
end
