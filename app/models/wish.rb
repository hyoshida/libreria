# == Schema Information
#
# Table name: wishes
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_wishes_on_book_id_and_user_id  (book_id,user_id) UNIQUE
#

class Wish < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  validates :book_id, uniqueness: { scope: :user_id }
  validates :book, presence: true
  validates :user, presence: true
end
