class OptionValue < ActiveRecord::Base
  belongs_to :option_type

  validates :name, uniqueness: { scope: :option_type_id }
  validates :option_type, presence: true
  validates :name, presence: true, length: { maximum: 255 }
end
