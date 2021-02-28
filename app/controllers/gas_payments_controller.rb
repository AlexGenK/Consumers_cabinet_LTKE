class GasPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_gas_payment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @current_gas_consumption = @consumer.current_gas_consumption
    @gas_payments = @consumer.gas_payments.all.order(:day)
    @sum_percent = @gas_payments.sum(:percent)
    @calculable = @current_gas_consumption && @gas_payments
    if @calculable
      # начальные и конечные даты предыдущего месяца
      start_prev = (Time.now.beginning_of_month - 1).beginning_of_month
      end_prev = Time.now.beginning_of_month - 1
      # выбираем стоимость потребление предыдущего месяца
      prev_cons = @consumer.previous_gas_consumption.where(date: start_prev..end_prev).first
      # находим стоимость потребленя следующего месяца
      if @consumer.gas_bid
        # выбор тарифа для расчета стоимости следующего месяца
        if (@current_gas_consumption.next_tariff != nil) && (@current_gas_consumption.next_tariff > 0)
          next_tariff = @current_gas_consumption.next_tariff
        else
          next_tariff = @current_gas_consumption.tariff 
        end

        next_cost = @consumer.gas_bid.month_sum((Time.now.end_of_month + 1.day).month) * next_tariff * 1.2
      else
        next_cost = 0
      end
      # рассчитываем баланс
      @balance = calculate_balance(@gas_payments, o_balance: @current_gas_consumption.opening_balance,
                                                  prev_cost: prev_cons&.cost_val,
                                                  cur_cost: @current_gas_consumption.cost_val,
                                                  next_cost: next_cost&.round(2),
                                                  money: @current_gas_consumption.money)
      @current_balance = get_current_balance(@balance, o_balance: @current_gas_consumption.opening_balance,
                                                       money: @current_gas_consumption.money)
      # выбираем цену для счета
      if @current_gas_consumption.tariff > 0
        # или тариф текщего месяца
        @current_tariff = @current_gas_consumption.tariff
      else
        # или тариф ближайшего предыдущего месяца
        @current_tariff = @consumer.previous_gas_consumption.order(:date).last&.tariff
      end
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

  def calculate_balance(payments, o_balance:, prev_cost: , cur_cost:, next_cost: , money:)
    prev_cost ||= 0
    next_cost ||= 0
    balance = []
    cur_balance = 0

    #расчет оплаты на начало месяца
    #расчет процентов долгов и предоплат на начало месяца
    debt_perc = 0
    prep_perc = 0

    payments.each { |payment| debt_perc += payment.percent if payment.month == 1 }
    payments.each { |payment| prep_perc += payment.percent if payment.month == -1 }

    #расчет общей суммы, которую надо заплатить, на начало месяца с учетом возможных долгов и предоплат
    begin_sum = ((cur_cost * prep_perc)/100 - (prev_cost * debt_perc)/100).round(2)

    #сколько есть оплат на начало месяца и начинаем майстрячить костыли
    if o_balance > 0
      total_payment = o_balance + money
    elsif (begin_sum < 0) and (o_balance > begin_sum)
      total_payment = o_balance - begin_sum + money
      begin_sum = 0
    else
      total_payment = money
      begin_sum += -o_balance
      if begin_sum < 0
        begin_sum = 0
      end
    end

    #рассчитываем, сколько уже оплачено из суммы, которую надо оплатить
    case total_payment
    when -Float::INFINITY..0
      cur_payment = 0
    when 0..begin_sum
      cur_payment = total_payment
    when begin_sum..Float::INFINITY
      cur_payment = begin_sum  
    end

    cur_balance = cur_balance + (begin_sum - cur_payment)
    total_payment -= begin_sum

    balance << {sum: begin_sum, cur_payment: cur_payment, cur_balance: cur_balance, day: 0}

    payments.each do |payment|
      case payment.month
      when 1
        sum = payment.percent*prev_cost/100
      when -1
        sum = payment.percent*next_cost/100
      else
        sum = payment.percent*cur_cost/100
      end

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
    cur_balance = 0
    balance.each do |item|
        if item[:day] <= current_day
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
