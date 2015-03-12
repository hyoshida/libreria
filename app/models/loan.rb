# == Schema Information
#
# Table name: loans
#
#  id          :integer          not null, primary key
#  book_id     :integer          not null
#  user_id     :integer          not null
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_loans_on_book_id_and_user_id_and_returned_at  (book_id,user_id,returned_at) UNIQUE
#

class Loan < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  validates :book_id, uniqueness: { scope: [:user_id, :returned_at] }
  validates :book, presence: true
  validates :user, presence: true
end
