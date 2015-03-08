class Organization < ActiveRecord::Base
  has_many :members

  accepts_nested_attributes_for :members

  validates :name, presence: true
  validates :published, presence: true
  validates :members, presence: true
end
