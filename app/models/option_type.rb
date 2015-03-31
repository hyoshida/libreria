class OptionType < ActiveRecord::Base
  has_many :option_values, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
