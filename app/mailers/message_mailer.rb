class MessageMailer < ApplicationMailer
	def new_message_email
		@consumer = params[:consumer]
		@message = params[:message]
		@manager = params[:manager]
		@client = User.find_by(name: @consumer.client_username)

		mail(to: [@manager.email, @client.email], subject: "Надіслано нове повідомлення")
	end
end
