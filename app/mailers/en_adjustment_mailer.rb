class EnAdjustmentMailer < ApplicationMailer
	def new_en_adjustment_email
		@consumer = params[:consumer]
		@en_adjustment = params[:en_adjustment]
		@manager = params[:manager]
		@client = User.find_by(name: @consumer.client_username)

		mail(to: [@manager.email, @client.email], subject: "Надіслано нове коригування обсягів споживання електроенергії")
	end
end
