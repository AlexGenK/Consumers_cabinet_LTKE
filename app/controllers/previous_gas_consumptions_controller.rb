class PreviousGasConsumptionsController < ApplicationController
	before_action :set_consumer
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
	load_and_authorize_resource

	def index
		@previous_gas_consumptions = @consumer.previous_gas_consumption.all.order(date: :desc)
    @certificate = @consumer.gas_certificate
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_gas_username)
  end
  
  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_gas_username != current_user.name
      else
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
end
