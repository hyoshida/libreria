# == Schema Information
#
# Table name: option_values
#
#  id             :integer          not null, primary key
#  option_type_id :integer          not null
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_option_values_on_option_type_id_and_name  (option_type_id,name) UNIQUE
#

class OptionValue < ActiveRecord::Base
  belongs_to :option_type

  validates :name, uniqueness: { scope: :option_type_id }
  validates :option_type, presence: true
  validates :name, presence: true, length: { maximum: 255 }
end
