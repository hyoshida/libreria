class User < ActiveRecord::Base
  extend Enumerize

  has_one :namespace, as: :ownerable

  accepts_nested_attributes_for :namespace

  validates :namespace, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  enumerize :role, in: %i(
    none
    admin
  ), default: :none, predicates: true
end
