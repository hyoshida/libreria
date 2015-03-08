class Namespace < ActiveRecord::Base
  belongs_to :ownerable, polymorphic: true

  validates :path, presence: true, uniqueness: true
end
