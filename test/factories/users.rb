FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| format('User Name ##{n}', n) }
    sequence(:email) { |n| format('libreria+%d@example.com', n) }
    password 'password'
    sequence(:namespace_attributes) { |n| { path: format('user-%d', n) } }
  end
end
