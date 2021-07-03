class DCompany < ApplicationRecord
  has_many :d_tariffs, dependent: :destroy
end
