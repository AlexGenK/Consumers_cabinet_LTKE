class PreviousGasConsumptionsController < ApplicationController
	before_action :set_consumer
	load_and_authorize_resource

	def index
		@previous_gas_consumptions = @consumer.previous_gas_consumption.all.order(date: :desc)
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_gas_username)
  end
end
