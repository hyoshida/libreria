# == Schema Information
#
# Table name: option_types
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_option_types_on_name  (name) UNIQUE
#

class OptionType < ActiveRecord::Base
  has_many :option_values, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
