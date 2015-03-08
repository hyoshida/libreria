FactoryGirl.define do
  factory :amazon_item do
    sequence(:asin)
    sequence(:item) do |n|
      {
        'Author' => 'author1',
        'Authors' => ['author1', 'author2'],
        'DetailPageURL' => 'http://example.com/',
        'MediumImage' => {
          'URL' => 'http://example.com/image.jpg'
        },
        'ItemAttributes' => {
          'Title' => "Example ##{n}",
          'Binding' => 'Kindle version',
        }
      }
    end

  end
end
