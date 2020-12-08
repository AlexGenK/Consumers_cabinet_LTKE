class MessagesController < ApplicationController
  before_action :set_consumer
  before_action :set_message, only: [:destroy]

  def index
    @messages = @consumer.messages.all.order(created_at: :desc).first(100)
    @message = @consumer.messages.new
  end

  def create
    @message = @consumer.messages.new(message_params)
    flash[:alert] = 'Неможливо створити запит' unless @message.save
    redirect_to consumer_messages_path(@consumer)
  end

  def destroy
    flash[:alert] = 'Неможливо видалити запит' unless @message.destroy
    redirect_to consumer_messages_path(@consumer)
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text, :comments, :state)
  end
end
