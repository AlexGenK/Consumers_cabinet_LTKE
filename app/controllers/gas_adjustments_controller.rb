class GasAdjustmentsController < ApplicationController
	before_action :set_consumer
  before_action :set_gas_adjustment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_gas_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_gas_adjustment
    @message = EnAdjustment.find(params[:id])
  end

  def gas_adjustment_params
    params.require(:gas_adjustment).permit(:month, :value, :comment, :state)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_gas_username != current_user.name
      elsif current_user.client_role?
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до коригування споживача, що Вам не належить або не існує"
  end
end
