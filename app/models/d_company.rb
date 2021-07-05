class DCompany < ApplicationRecord
  has_many :d_tariffs, dependent: :destroy

  validates :name, uniqueness: true
  validates :name, presence: true
end
