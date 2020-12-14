class PreviousGasConsumptionsController < ApplicationController
	before_action :set_consumer

	def index
		@previous_gas_consumptions = @consumer.previous_gas_consumption.all.order(date: :desc)
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
