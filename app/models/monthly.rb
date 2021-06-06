class Monthly < ApplicationRecord
  belongs_to :consumer
  has_many :dailies, dependent: :destroy

  def text_period
    "#{UA_MONTHS_SINGLE[self.date_cons.month]} #{self.date_cons.year}"
  end
end
