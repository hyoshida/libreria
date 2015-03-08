class Namespace < ActiveRecord::Base
  belongs_to :ownerable, polymorphic: true

  validates :path, presence: true, uniqueness: true

  def owners
    if ownerable.is_a? Organization
      ownerable.owners.to_a
    else
      [ownerable]
    end
  end

  def owner
    owners.first
  end
end
