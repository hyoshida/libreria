class BooksOptionValue < ActiveRecord::Base
  belongs_to :book
  belongs_to :option_value
end
