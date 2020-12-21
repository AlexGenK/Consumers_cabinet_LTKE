class PreviousEnConsumptionsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_consumer

	def index
		@previous_en_consumptions = @consumer.previous_en_consumption.all.order(date: :desc)
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
