# == Schema Information
#
# Table name: members
#
#  id                  :integer          not null, primary key
#  organization_id     :integer          not null
#  user_id             :integer          not null
#  role                :string           not null
#  activated           :boolean          default(TRUE), not null
#  request_token       :string
#  request_sent_at     :datetime
#  request_accepted_at :datetime
#  request_acceptor_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_members_on_organization_id_and_user_id  (organization_id,user_id) UNIQUE
#  index_members_on_request_token                (request_token) UNIQUE
#

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
