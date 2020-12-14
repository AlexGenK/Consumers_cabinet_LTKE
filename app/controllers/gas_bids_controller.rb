class GasBidsController < ApplicationController
  before_action :set_consumer
  before_action :set_gas_bid

  def show
  end

  def edit
  end

  def update
    if @gas_bid.update(gas_bid_params)
      flash[:alert] = nil
      redirect_to consumer_gas_bid_path(@consumer)
    else
      flash[:alert] = 'Неможливо відредагувати заявку'
      render :edit
    end
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_gas_bid
    @gas_bid = Consumer.find(params[:consumer_id]).gas_bid
    @gas_bid ||= @consumer.create_gas_bid
  end

  def gas_bid_params
    params.require(:gas_bid).permit(:jan, :feb, :mar, :apr, :may, :jun,
    																:jul, :aug, :sep, :okt, :nov, :dec)
  end
end
