FactoryGirl.define do
  factory :option_value do
    sequence(:name) { |n| "OptionValue ##{n}" }
    option_type { build_stubbed(:option_type, :with_namespace) }
  end
end
