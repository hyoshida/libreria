class Member < ActiveRecord::Base
  extend Enumerize
  include Member::Requestable

  belongs_to :organization
  belongs_to :user

  validates :organization_id, uniqueness: { scope: :user_id }
  validates :user, presence: true
  validates :role, presence: true, length: { maximum: 255 }

  scope :activated, -> { unscope(where: :activated).where(activated: true) }
  scope :inactivated, -> { unscope(where: :activated).where(activated: false) }

  default_scope { activated }

  enumerize :role, in: %i(
    none
    owner
  ), default: :none, predicates: true, scope: true

  delegate :email, to: :user
  delegate :name, to: :user
end
