class EnPayment < ApplicationRecord
  belongs_to :consumer
  validates :day, numericality: { less_than_or_equal_to: 31, greater_than: 0 }
  validates :percent, numericality: { less_than_or_equal_to: 100, greater_than: 0 }
end
