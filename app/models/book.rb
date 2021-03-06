# == Schema Information
#
# Table name: books
#
#  id             :integer          not null, primary key
#  amazon_item_id :integer          not null
#  namespace_id   :integer          not null
#  state          :string           not null
#  location_name  :string
#  arrived_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_books_on_amazon_item_id_and_namespace_id  (amazon_item_id,namespace_id) UNIQUE
#

class Book < ActiveRecord::Base
  belongs_to :namespace
  belongs_to :amazon_item
  # TODO: Should change the dependent of associations to soft-delete
  has_many :wishes, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :books_option_value, dependent: :destroy
  has_many :option_values, through: :books_option_value

  accepts_nested_attributes_for :option_values

  validates :amazon_item_id, uniqueness: { scope: :namespace_id }
  validates :namespace, presence: true
  validates :amazon_item, presence: true
  validates :state, length: { maximum: 255 }
  validates :location_name, length: { maximum: 255 }

  delegate *%i(
    asin
    item
    detail_page_url
    medium_image_url
    title
    authors
    binding
  ), to: :amazon_item

  delegate :owners, to: :namespace
  delegate :owner, to: :namespace

  alias_method :name, :title

  state_machine initial: :wished do
    state :wished
    state :ready, :onloan do
      validates :arrived_at, presence: true
    end

    event :arrived do
      transition :wished => :ready
    end

    event :loaned do
      transition :ready => :onloan
    end

    event :returned do
      transition :onloan => :ready
    end

    before_transition :wished => :ready do |book, _transition|
      book.arrived_at = Time.now
    end

    before_transition :onloan => :ready do |book, _transition|
      loan = book.loans.unreturned.first
      return false unless loan
      loan.touch(:returned_at)
    end
  end

  class << self
    def item_search(query, options = {})
      amazon_api do
        default_option = amazon_api_default_options.merge(search_index: 'Books')
        Amazon::Ecs.item_search(query, options.reverse_merge(default_option))
      end
    end

    def item_lookup(asin, options = {})
      amazon_api do
        Amazon::Ecs.item_lookup(asin, options.reverse_merge(amazon_api_default_options))
      end
    end

    private

    def amazon_api
      yield
    rescue
      retry_count ||= 0
      retry_count += 1
      retry if retry_count <= 5
      raise
    end

    def amazon_api_default_options
      { response_group: 'Medium', country: 'jp', power: 'binding:not kindle' }
    end
  end

  def associate_amazon_item_by(asin)
    amazon_item = AmazonItem.find_by(asin: asin)
    if amazon_item.nil?
      result = self.class.item_lookup(asin)
      return unless result

      item = self.class.item_lookup(asin).items.first
      return unless item
      amazon_item = AmazonItem.create!(asin: item.get('ASIN'), item: item.to_json)
    end
    self.amazon_item = amazon_item
  end

  def borrower
    loans.unreturned.first.try(:user)
  end
end
