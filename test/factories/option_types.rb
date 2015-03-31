FactoryGirl.define do
  factory :option_type do
    sequence(:name) { |n| "OptionType ##{n}" }
  end
end
