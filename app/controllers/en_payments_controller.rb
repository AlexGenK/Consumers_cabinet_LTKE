class EnPaymentsController < ApplicationController
  before_action :set_consumer

  def index
    @en_payments = @consumer.en_payments.all.order(:day)
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
	
end
