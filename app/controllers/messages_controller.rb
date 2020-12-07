class MessagesController < ApplicationController
  before_action :set_consumer

  def index
    @messages = @consumer.messages.all.order(:created_at)
    @message = @consumer.messages.new
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
