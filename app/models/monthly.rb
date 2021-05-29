class Monthly < ApplicationRecord
  belongs_to :consumer
  has_many :dailies, dependent: :destroy
end
