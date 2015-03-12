FactoryGirl.define do
  factory :loan do
    transient do
      namespace { build_stubbed(:namespace, :with_user) }
    end

    book { build(:book, namespace: namespace) }
    user
  end
end
