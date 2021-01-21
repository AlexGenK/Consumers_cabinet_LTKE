class EnAdjustment < ApplicationRecord
  belongs_to :consumer
  validates :value, numericality: { greater_than: 0 }, presence: true
end
