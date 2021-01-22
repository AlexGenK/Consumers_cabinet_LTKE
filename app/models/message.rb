class Message < ApplicationRecord
  belongs_to :consumer
  has_one_attached :attach, dependent: :destroy
end
