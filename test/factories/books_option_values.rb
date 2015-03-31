FactoryGirl.define do
  factory :books_option_value do
    book { build(:book, namespace: build_stubbed(:namespace, :with_user)) }
    option_value
  end
end
