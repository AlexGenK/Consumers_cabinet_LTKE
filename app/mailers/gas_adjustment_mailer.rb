class GasAdjustmentMailer < ApplicationMailer
	def new_gas_adjustment_email
		@consumer = params[:consumer]
		@gas_adjustment = params[:gas_adjustment]
		@receiver = Receiver.first
		@client = User.find_by(name: @consumer.client_username)

		mail(to: [@receiver.adjustment_email, @client.email], subject: "Надіслано нове коригування обсягів споживання газу")
	end
end
