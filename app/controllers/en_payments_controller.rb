class EnPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_en_payment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @current_en_consumption = @consumer.current_en_consumption
    @en_payments = @consumer.en_payments.all.order(:day)
    @calculable = @current_en_consumption && @en_payments
    if @calculable
      @balance = calculate_balance(@en_payments, o_balance: @current_en_consumption.opening_balance,
                                                 tariff: @current_en_consumption.tariff,
                                                 power: @current_en_consumption.power,
                                                 money: @current_en_consumption.money)
      @current_balance = get_current_balance(@balance, o_balance: @current_en_consumption.opening_balance,
                                                       money: @current_en_consumption.money)
    end
    @en_payment = @consumer.en_payments.new
  end

  def create
    @en_payment = @consumer.en_payments.new(en_payment_params)
    if (@consumer.en_payments.sum(:percent) + @en_payment.percent.to_i) > 100
      flash[:alert] = 'Неможливо створити платіж. Планові платежі перевищили 100%'
    else
      flash[:alert] = 'Неможливо створити платіж. Введіть коректні значення' unless @en_payment.save
    end
    redirect_to consumer_en_payments_path(@consumer)
  end

  def destroy
    flash[:alert] = 'Неможливо видалити платіж' unless @en_payment.destroy
    redirect_to consumer_en_payments_path(@consumer)
  end

  def edit
  end

  def update
    if @en_payment.update(en_payment_params)
      redirect_to consumer_en_payments_path(@consumer)
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
    @manager = User.find_by(name: @consumer.manager_en_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def set_en_payment
    @en_payment = EnPayment.find(params[:id])
  end

  def en_payment_params
    params.require(:en_payment).permit(:day, :percent, :month)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_en_username != current_user.name
      else
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
	
end
