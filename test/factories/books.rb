FactoryGirl.define do
  factory :book do
    amazon_item

    trait :with_namespace do
      namespace { build_stubbed(:namespace, :with_user) }
    end
  end
end
