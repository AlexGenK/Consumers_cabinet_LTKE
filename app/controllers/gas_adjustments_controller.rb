class GasAdjustmentsController < ApplicationController
	before_action :set_consumer
  before_action :set_gas_adjustment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @adjustments = @consumer.gas_adjustments.all.order(created_at: :desc).first(100)
    @adjustment = @consumer.gas_adjustments.new(month: Time.now.month)
  end

  def create
    @adjustment = @consumer.gas_adjustments.new(gas_adjustment_params)
    if @adjustment.save
      GasAdjustmentMailer.with(consumer: @consumer, manager: @manager, gas_adjustment: @adjustment).new_gas_adjustment_email.deliver_later
    else
      flash[:alert] = 'Неможливо створити коригування'
    end
    redirect_to consumer_gas_adjustments_path(@consumer)
  end

  def edit
  end

  def update
    if @gas_adjustment.update(gas_adjustment_params)
      redirect_to consumer_gas_adjustments_path(@consumer)
    else
      flash[:alert] = 'Неможливо відредагувати коригування'
      render :edit
    end
  end

  def destroy
    flash[:alert] = 'Неможливо видалити коригування' unless @gas_adjustment.destroy
    redirect_to consumer_gas_adjustments_path(@consumer)
  end


  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_gas_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_gas_adjustment
    @message = GasAdjustment.find(params[:id])
  end

  def gas_adjustment_params
    params.require(:gas_adjustment).permit(:month, :value, :comment, :state)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_gas_username != current_user.name
      elsif current_user.client_role?
        consumers = @consumer.users.map{|n| n.name}
        consumers << @consumer.client_username
        denied_action unless consumers.include?(current_user.name)
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до коригування споживача, що Вам не належить або не існує"
  end
end
