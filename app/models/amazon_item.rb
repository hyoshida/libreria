class AmazonItem < ActiveRecord::Base
  validates :asin, presence: true, uniqueness: true
  validates :item, presence: true
end
