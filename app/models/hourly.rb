class Hourly < ApplicationRecord
  belongs_to :daily

  validates :hour_cons, numericality: { greater_than_or_equal_to: 1 }
  validates :hour_cons, numericality: { less_than_or_equal_to: 25 }
end
