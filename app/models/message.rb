class Message < ApplicationRecord
  belongs_to :consumer
  has_one_attached :attach, dependent: :destroy

  validates :attach, size: { less_than: 1.megabytes , message: 'Розмір вкладення повинен бути менше 1 МБ' }
end
