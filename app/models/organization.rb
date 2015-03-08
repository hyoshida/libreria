class Organization < ActiveRecord::Base
  has_one :namespace, as: :ownerable
  has_many :members
  has_many :_owner_members, -> { with_role(:owner) }, class_name: Member.name
  has_many :owners, through: :_owner_members, source: :user

  accepts_nested_attributes_for :namespace
  accepts_nested_attributes_for :members

  validates :name, presence: true
  validates :published, presence: true
  validates :namespace, presence: true
  validates :members, presence: true
end
