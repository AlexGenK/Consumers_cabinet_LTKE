class GasBidsController < ApplicationController
  before_action :set_consumer
  before_action :set_gas_bid
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

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
    @manager = User.find_by(name: @consumer.manager_gas_username)
  end

  def set_gas_bid
    @gas_bid = Consumer.find(params[:consumer_id]).gas_bid
    @gas_bid ||= @consumer.create_gas_bid
  end

  def gas_bid_params
    params.require(:gas_bid).permit(:jan, :feb, :mar, :apr, :may, :jun,
    																:jul, :aug, :sep, :okt, :nov, :dec)
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
