# == Schema Information
#
# Table name: namespaces
#
#  id             :integer          not null, primary key
#  ownerable_id   :integer          not null
#  ownerable_type :string           not null
#  path           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_namespaces_on_ownerable_type_and_ownerable_id  (ownerable_type,ownerable_id)
#  index_namespaces_on_path                             (path) UNIQUE
#

class Namespace < ActiveRecord::Base
  belongs_to :ownerable, polymorphic: true

  validates :path, presence: true, uniqueness: true, length: { maximum: 255 }

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
