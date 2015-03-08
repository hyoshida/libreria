class Member < ActiveRecord::Base
  extend Enumerize

  belongs_to :organization
  belongs_to :user

  validates :user, presence: true
  validates :role, presence: true

  enumerize :role, in: %i(
    none
    owner
  ), default: :none, predicates: true
end
