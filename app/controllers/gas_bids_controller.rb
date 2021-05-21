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
      recalc_cur_cons
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
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_gas_bid
    @gas_bid = Consumer.find(params[:consumer_id]).gas_bid
    @gas_bid ||= @consumer.create_gas_bid
  end

  def gas_bid_params
    params.require(:gas_bid).permit(:jan, :feb, :mar, :apr, :may, :jun,
    																:jul, :aug, :sep, :okt, :nov, :dec)
  end

  def recalc_cur_cons
    cur_cons = @consumer.current_gas_consumption
    if cur_cons
      volume = @consumer.gas_bid.month_sum(Time.now.month)
      cost = (volume * cur_cons.tariff).round(2)
      cost_val = (cost * 1.2).round(2)
      closing_balance = cur_cons.opening_balance - cost_val + cur_cons.money

      cur_cons.volume = volume
      cur_cons.cost = cost
      cur_cons.cost_val = cost_val
      cur_cons.closing_balance = closing_balance

      cur_cons.save 
    end
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_gas_username != current_user.name
      else
        consumers = @consumer.users.map{|n| n.name}
        consumers << @consumer.client_username
        denied_action unless consumers.include?(current_user.name)
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
end
