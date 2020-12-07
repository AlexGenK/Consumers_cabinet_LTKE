class MessagesController < ApplicationController
  before_action :set_consumer

  def index
    @messages = @consumer.messages.all.order(:created_at)
    @message = @consumer.messages.new
  end

  def create
    @message = @consumer.messages.new(message_params)
    flash[:alert] = 'Неможливо створити платіж' unless @message.save
    redirect_to consumer_messages_path(@consumer)
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def message_params
    params.require(:message).permit(:text, :comments, :state)
  end
end
