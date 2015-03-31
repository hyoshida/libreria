FactoryGirl.define do
  factory :books_option_value do
    book { build_stubbed(:book, :with_namespace) }
    option_value
  end
end
