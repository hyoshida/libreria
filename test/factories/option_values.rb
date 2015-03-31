FactoryGirl.define do
  factory :option_value do
    sequence(:name) { |n| "OptionValue ##{n}" }
    option_type
  end
end
