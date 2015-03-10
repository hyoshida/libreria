class Member < ActiveRecord::Base
  extend Enumerize

  belongs_to :organization
  belongs_to :user

  validates :organization_id, uniqueness: { scope: :user_id }
  validates :user, presence: true
  validates :role, presence: true, length: { maximum: 255 }

  enumerize :role, in: %i(
    none
    owner
  ), default: :none, predicates: true, scope: true

  delegate :email, to: :user
end
