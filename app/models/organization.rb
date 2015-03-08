class Organization < ActiveRecord::Base
  validates :name, presence: true
  validates :published, presence: true
end
