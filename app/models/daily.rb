class Daily < ApplicationRecord
  belongs_to :monthly

  validates :day_cons, numericality: { greater_than_or_equal_to: 1 }
  validates :day_cons, numericality: { less_than_or_equal_to: 31 }
end
