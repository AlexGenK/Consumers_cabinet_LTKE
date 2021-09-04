class EnAdjustmentMailer < ApplicationMailer
	def new_en_adjustment_email
		@consumer = params[:consumer]
		@en_adjustment = params[:en_adjustment]
		@receiver = Receiver.first
		@client = User.find_by(name: @consumer.client_username)

		mail(to: [@receiver.adjustment_email, @client.email], subject: "Надіслано нове коригування обсягів споживання електроенергії")
	end
end
