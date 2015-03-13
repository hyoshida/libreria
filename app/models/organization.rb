# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  published  :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ActiveRecord::Base
  has_one :namespace, as: :ownerable, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  accepts_nested_attributes_for :namespace
  accepts_nested_attributes_for :members

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: Devise.email_regexp }
  validates :published, presence: true
  validates :namespace, presence: true
  validates :members, presence: true

  before_validation :copy_email_from_owner, on: :create
  before_validation :copy_name_from_namespace, on: :create

  delegate :path, to: :namespace

  def to_param
    path
  end

  def owners
    User.joins(:members).merge(members.with_role(:owner))
  end

  def username
    namespace.path
  end

  private

  def copy_email_from_owner
    owner = members.first
    return unless owner
    self.email = owner.email
  end

  def copy_name_from_namespace
    self.name = username
  end
end
