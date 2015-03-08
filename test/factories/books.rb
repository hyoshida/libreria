FactoryGirl.define do
  factory :book do
    amazon_item_attributes { attributes_for(:amazon_item) }
  end
end
