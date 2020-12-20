class MessagesController < ApplicationController
  before_action :set_consumer
  before_action :set_message, only: [:destroy, :edit, :update]

  def index
    @messages = @consumer.messages.all.order(created_at: :desc).first(100)
    @message = @consumer.messages.new
  end

  def create
    @message = @consumer.messages.new(message_params)
    if @message.save
      MessageMailer.with(consumer: @consumer, message: @message).new_message_email.deliver_now
    else
      flash[:alert] = 'Неможливо створити запит'
    end
    if params[:cab] == 'gas'
      redirect_to consumer_messages_path(@consumer, cab: 'gas')
    else
      redirect_to consumer_messages_path(@consumer)
    end
  end

  def destroy
    flash[:alert] = 'Неможливо видалити запит' unless @message.destroy
    if params[:cab] == 'gas'
      redirect_to consumer_messages_path(@consumer, cab: 'gas')
    else
      redirect_to consumer_messages_path(@consumer)
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      if params[:cab] == 'gas'
        redirect_to consumer_messages_path(@consumer, cab: 'gas')
      else
        redirect_to consumer_messages_path(@consumer)
      end
    else
      flash[:alert] = 'Неможливо відредагувати запит'
      render :edit
    end
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text, :comment, :state)
  end
end
