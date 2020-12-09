class Consumer < ApplicationRecord
	has_many :en_payments
	has_many :en_bids
	has_many :messages
end
