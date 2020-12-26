class MessagesController < ApplicationController
  before_action :set_consumer
  before_action :set_message, only: [:destroy, :edit, :update]
  load_and_authorize_resource

  def index
    @messages = @consumer.messages.all.order(created_at: :desc).first(100)
    @message = @consumer.messages.new
  end

  def create
    @message = @consumer.messages.new(message_params)
    if @message.save
      MessageMailer.with(consumer: @consumer, message: @message).new_message_email.deliver_later
    else
      flash[:alert] = 'Неможливо створити запит'
    end
    redirect_to consumer_messages_path(@consumer, cab: params[:cab])
  end

  def destroy
    flash[:alert] = 'Неможливо видалити запит' unless @message.destroy
    redirect_to consumer_messages_path(@consumer, cab: params[:cab])
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to consumer_messages_path(@consumer, cab: params[:cab])
    else
      flash[:alert] = 'Неможливо відредагувати запит'
      render :edit
    end
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = (params[:cab]=='gas' ? User.find_by(name: @consumer.manager_gas_username) : User.find_by(name: @consumer.manager_en_username))
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text, :comment, :state)
  end
end
