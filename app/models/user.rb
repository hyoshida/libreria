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
         :omniauthable, omniauth_providers: [:google]

  enumerize :role, in: %i(
    none
    admin
  ), default: :none, predicates: true

  class << self
    def from_omniauth(auth)
      uid_column = "#{auth.provider}_uid"
      user = where(uid_column => auth.uid).first
      user ||= where(email: auth.info.email).first_or_initialize
      user.attributes = {
        uid_column => auth.uid,
        name: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        namespace_attributes: { path: auth.info.email.split('@').first }
      }
      user
    end

    # This method called by new oauth user
    def new_with_session(params, session)
      super.tap do |user|
        auth = find_provider_and_auth_from_session(session)
        if auth
          user.send("#{auth['provider']}_uid=", auth['uid'])
          user.name = auth['info']['name'] if user.name.blank?
          user.email = auth['info']['email'] if user.email.blank?
          user.build_namespace(path: auth['info']['email'].split('@').first) unless user.namespace
        end
      end
    end

    private

    def find_provider_and_auth_from_session(session)
      omniauth_providers.each do |provider|
        auth = session["devise.#{provider}_data"]
        return auth if auth
      end
      nil
    end
  end

  def to_param
    path
  end

  def as_json(options)
    { id: id, text: email }
  end

  def username
    namespace.path
  end

  private

  def copy_name_from_namespace
    self.name ||= username
  end
end
