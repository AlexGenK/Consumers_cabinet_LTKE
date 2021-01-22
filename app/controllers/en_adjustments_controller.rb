class EnAdjustmentsController < ApplicationController
	before_action :set_consumer
  before_action :set_en_adjustment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @adjustments = @consumer.en_adjustments.all.order(created_at: :desc).first(100)
    @adjustment = @consumer.en_adjustments.new(month: Time.now.month)
  end

  def create
    @adjustment = @consumer.en_adjustments.new(en_adjustment_params)
    if @adjustment.save
      EnAdjustmentMailer.with(consumer: @consumer, manager: @manager, en_adjustment: @adjustment).new_en_adjustment_email.deliver_later
    else
      flash[:alert] = 'Неможливо створити коригування'
    end
    redirect_to consumer_en_adjustments_path(@consumer)
  end

  def edit
  end

  def update
    if @en_adjustment.update(en_adjustment_params)
      redirect_to consumer_en_adjustments_path(@consumer)
    else
      flash[:alert] = 'Неможливо відредагувати коригування'
      render :edit
    end
  end

  def destroy
    flash[:alert] = 'Неможливо видалити коригування' unless @en_adjustment.destroy
    redirect_to consumer_en_adjustments_path(@consumer)
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_en_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_en_adjustment
    @en_adjustment = EnAdjustment.find(params[:id])
  end

  def en_adjustment_params
    params.require(:en_adjustment).permit(:month, :value, :comment, :state)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_en_username != current_user.name
      elsif current_user.client_role?
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до коригування споживача, що Вам не належить або не існує"
  end
end
