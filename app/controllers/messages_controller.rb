class MessagesController < ApplicationController
  before_action :set_consumer
  before_action :set_message, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @messages = @consumer.messages.all.order(created_at: :desc).first(100)
    @message = @consumer.messages.new
  end

  def create
    @message = @consumer.messages.new(message_params)
    if @message.save
      MessageMailer.with(consumer: @consumer, manager: @manager, message: @message).new_message_email.deliver_later
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
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text, :comment, :state)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if (@consumer.manager_en_username != current_user.name) &&
                         (@consumer.manager_gas_username != current_user.name)
      elsif current_user.client_role?
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до запітив споживача, що Вам не належить або не існує"
  end
end
