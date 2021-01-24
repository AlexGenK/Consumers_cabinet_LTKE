class GasPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_gas_payment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @current_gas_consumption = @consumer.current_gas_consumption
    @gas_payments = @consumer.gas_payments.all.order(:day)
    @calculable = @current_gas_consumption && @gas_payments
    if @calculable
      @balance = calculate_balance(@gas_payments, o_balance: @current_gas_consumption.opening_balance,
                                                  tariff: @current_gas_consumption.tariff,
                                                  power: @current_gas_consumption.volume,
                                                  money: @current_gas_consumption.money)
      @current_balance = get_current_balance(@balance, o_balance: @current_gas_consumption.opening_balance,
                                                       money: @current_gas_consumption.money)
    end
    @gas_payment = @consumer.gas_payments.new
  end

  def create
    @gas_payment = @consumer.gas_payments.new(gas_payment_params)
    if (@consumer.gas_payments.sum(:percent) + @gas_payment.percent.to_i) > 100
      flash[:alert] = 'Неможливо створити платіж. Планові платежі перевищили 100%'
    else
      flash[:alert] = 'Неможливо створити платіж. Введіть коректні значення' unless @gas_payment.save
    end
    redirect_to consumer_gas_payments_path(@consumer)
  end

  def destroy
    flash[:alert] = 'Неможливо видалити платіж' unless @gas_payment.destroy
    redirect_to consumer_gas_payments_path(@consumer)
  end

  def edit
  end

  def update
    if @gas_payment.update(gas_payment_params)
      redirect_to consumer_gas_payments_path(@consumer)
    else
      flash[:alert] = 'Неможливо відредагувати платіж'
      render :edit
    end
  end

  private

  def calculate_balance(payments, o_balance:, tariff:, power:, money:)
    balance = []
    if money+o_balance > 0
      cur_balance = 0
    else
      cur_balance = -o_balance-money
    end
    all_cost = tariff * power * 1.2
    total_payment = o_balance + money
    payments.each do |payment|
      sum = payment.percent*all_cost/100
      case total_payment
      when -Float::INFINITY..0
        cur_payment = 0
      when 0..sum
        cur_payment = total_payment
      when sum..Float::INFINITY
        cur_payment = sum  
      end
      cur_balance = cur_balance + (sum - cur_payment)
      total_payment -= sum
      balance << {sum: sum, cur_payment: cur_payment, cur_balance: cur_balance, day: payment.day}
    end
    return balance
  end

  def get_current_balance(balance, o_balance:, money:)
    current_day = Time.now.day
    if money+o_balance > 0
      cur_balance = 0
    else
      cur_balance = -o_balance-money
    end
    balance.each do |item|
        if item[:day] <= current_day
          p item[:cur_balance]
          cur_balance = item[:cur_balance]
        else
          break
        end
    end
    return cur_balance
  end

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_gas_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_gas_payment
    @gas_payment = GasPayment.find(params[:id])
  end

  def gas_payment_params
    params.require(:gas_payment).permit(:day, :percent, :month)
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
