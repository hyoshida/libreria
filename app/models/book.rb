class Book < ActiveRecord::Base
  belongs_to :amazon_item

  accepts_nested_attributes_for :amazon_item

  validates :amazon_item, presence: true

  delegate :asin, to: :amazon_item
  delegate :item, to: :amazon_item

  state_machine initial: :requested do
    state :requested
    state :ready, :onloan do
      validates :arrived_at, presence: true
    end

    event :arrived do
      transition :requested => :ready
    end

    event :loaned do
      transition :ready => :onloan
    end

    event :returned do
      transition :onloan => :ready
    end

    before_transition any => :ready do |book, _transition|
      book.arrived_at = Time.now
    end
  end
end
