# == Schema Information
#
# Table name: amazon_items
#
#  id         :integer          not null, primary key
#  asin       :string           not null
#  item       :json             default({}), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_amazon_items_on_asin  (asin) UNIQUE
#

class AmazonItem < ActiveRecord::Base
  validates :asin, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :item, presence: true

  def detail_page_url
    item['DetailPageURL']
  end

  def medium_image_url
    medium_image['URL']
  end

  def title
    item_attributes['Title']
  end

  def authors
    item_attributes['Authors'] || []
  end

  def binding
    item_attributes['Binding']
  end

  private

  def item_attributes
    item['ItemAttributes'] || {}
  end

  def medium_image
    item['MediumImage'] || {}
  end
end
