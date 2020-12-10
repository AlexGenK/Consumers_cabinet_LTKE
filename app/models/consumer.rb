class Consumer < ApplicationRecord
	has_many :en_payments
	has_one :en_bid
	has_many :messages
end
