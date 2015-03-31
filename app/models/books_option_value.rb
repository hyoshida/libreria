# == Schema Information
#
# Table name: books_option_values
#
#  id              :integer          not null, primary key
#  book_id         :integer          not null
#  option_value_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_books_option_values_on_book_id_and_option_value_id  (book_id,option_value_id) UNIQUE
#

class BooksOptionValue < ActiveRecord::Base
  belongs_to :book
  belongs_to :option_value

  validates :option_value_id, uniqueness: { scope: :book_id }
  validates :book, presence: true
  validates :option_value, presence: true
end
