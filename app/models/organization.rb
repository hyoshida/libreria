class Organization < ActiveRecord::Base
  has_one :namespace, as: :ownerable
  has_many :members
  has_many :users, through: :members
  has_many :owners, through: :_owner_members, source: :user
  has_many :_owner_members, -> { with_role(:owner) }, class_name: Member.name

  accepts_nested_attributes_for :namespace
  accepts_nested_attributes_for :members

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: Devise.email_regexp }
  validates :published, presence: true
  validates :namespace, presence: true
  validates :members, presence: true

  before_validation :copy_email_from_owner, on: :create

  private

  def copy_email_from_owner
    owner = members.first
    return unless owner
    self.email = owner.email
  end
end
