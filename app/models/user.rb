# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  role                   :string           not null
#  email                  :string           not null
#  encrypted_password     :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  google_uid             :string
#  facebook_uid           :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  extend Enumerize

  has_one :namespace, as: :ownerable, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :organizations, through: :members
  # TODO: Should change the dependent of associations to soft-delete
  has_many :wishes, dependent: :destroy
  has_many :loans, dependent: :destroy

  accepts_nested_attributes_for :namespace

  validates :namespace, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :role, presence: true, length: { maximum: 255 }

  before_validation :copy_name_from_namespace, on: :create

  delegate :path, to: :namespace

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google, :facebook]

  # Please insert after `devise` method to override `new_with_session` method.
  include User::Omniauthble

  enumerize :role, in: %i(
    none
    admin
  ), default: :none, predicates: true

  def to_param
    path
  end

  def as_json(options)
    { id: id, text: email }
  end

  def username
    namespace.path if namespace
  end

  private

  def copy_name_from_namespace
    self.name ||= username
  end
end
