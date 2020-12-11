class Consumer < ApplicationRecord
	has_many :en_payments
	has_one :en_bid
	has_many :messages
	has_many :previous_en_consumption

	def has_new_message?
		self.messages.where("state = 0").count > 0
	end
end
