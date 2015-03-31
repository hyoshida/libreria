# == Schema Information
#
# Table name: option_types
#
#  id           :integer          not null, primary key
#  namespace_id :integer          not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_option_types_on_namespace_id_and_name  (namespace_id,name) UNIQUE
#

class OptionType < ActiveRecord::Base
  belongs_to :namespace
  has_many :option_values, dependent: :destroy

  validates :name, uniqueness: { scope: :namespace_id }
  validates :namespace, presence: true
  validates :name, presence: true, length: { maximum: 255 }
end
