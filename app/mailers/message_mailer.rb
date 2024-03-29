class MessageMailer < ApplicationMailer
	def new_message_email
		@consumer = params[:consumer]
		@message = params[:message]
		@receiver = Receiver.first
		@client = User.find_by(name: @consumer.client_username)

		mail(to: [@receiver.message_email, @client.email], subject: "Надіслано нове повідомлення")
	end
end
