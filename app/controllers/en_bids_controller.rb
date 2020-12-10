class EnBidsController < ApplicationController
	before_action :set_consumer
	before_action :set_en_bid

	def show
		@en_bid ||= @consumer.build_en_bid
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_en_bid
    @en_bin = Consumer.find(params[:consumer_id]).en_bid
  end
end
