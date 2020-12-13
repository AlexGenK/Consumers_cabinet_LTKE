class Consumer < ApplicationRecord
	has_many :en_payments
	has_one  :en_bid
	has_many :previous_en_consumption
	has_one  :current_en_consumption

	has_many :gas_payments

	has_many :messages

	validates :name, :onec_id, presence: true, uniqueness: true

	def has_new_message?
		self.messages.where("state = 0").count > 0
	end
end
