class BooksOptionValue < ActiveRecord::Base
  belongs_to :book
  belongs_to :option_value

  validates :option_value_id, uniqueness: { scope: :book_id }
  validates :book, presence: true
  validates :option_value, presence: true
end
