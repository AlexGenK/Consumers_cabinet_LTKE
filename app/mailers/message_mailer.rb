class MessageMailer < ApplicationMailer
	def new_message_email
		@consumer = params[:consumer]

		mail(to: ENV['CONSUMERS_CABINET_LTKE_TESTEMAIL'], subject: "Надіслано нове повідомлення")
	end
end
