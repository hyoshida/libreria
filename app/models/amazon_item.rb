class AmazonItem < ActiveRecord::Base
  validates :asin, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :item, presence: true
end
