class Consumer < ApplicationRecord
	has_many :en_payments, dependent: :destroy
	has_one  :en_bid, dependent: :destroy
	has_many :previous_en_consumption, dependent: :destroy
	has_one  :current_en_consumption, dependent: :destroy
	has_one  :en_certificate, dependent: :destroy
	has_many :en_adjustments, dependent: :destroy

	has_many :gas_payments, dependent: :destroy
	has_one  :gas_bid, dependent: :destroy
	has_many :previous_gas_consumption, dependent: :destroy
	has_one  :current_gas_consumption, dependent: :destroy
	has_one  :gas_certificate, dependent: :destroy
	has_many :gas_adjustments, dependent: :destroy

	has_many :messages, dependent: :destroy

	validates :name, :onec_id, presence: true

	def has_new_message?
		self.messages.where("state = 0").count > 0
	end

	def has_new_en_adjustment?
		self.en_adjustments.where("state = 0").count > 0
	end

	def has_new_gas_adjustment?
		self.gas_adjustments.where("state = 0").count > 0
	end
end
