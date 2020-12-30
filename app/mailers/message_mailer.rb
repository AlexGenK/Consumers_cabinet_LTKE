class MessageMailer < ApplicationMailer
	def new_message_email
		@consumer = params[:consumer]
		@message = params[:message]
		@manager = params[:manager]

		mail(to: @manager.email, subject: "Надіслано нове повідомлення")
	end
end
