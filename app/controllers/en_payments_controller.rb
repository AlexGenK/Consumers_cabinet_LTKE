class EnPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_en_payment, only: [:destroy, :edit, :update]
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    @current_en_consumption = @consumer.current_en_consumption
    @en_payments = @consumer.en_payments.all.order(:day)
    @sum_percent = @en_payments.sum(:percent)
    @calculable = @current_en_consumption && @en_payments
    if @calculable
      # начальные и конечные даты предыдущего месяца
      start_prev = (Time.now.beginning_of_month - 1).beginning_of_month
      end_prev = Time.now.beginning_of_month - 1
      # выбираем стоимость потребление предыдущего месяца
      prev_cons = @consumer.previous_en_consumption.where(date: start_prev..end_prev).first
      # находим стоимость потребленя следующего месяца
      if @consumer.en_bid
        # выбор тарифа для расчета стоимости следующего месяца
        if (@current_en_consumption.next_tariff != nil) && (@current_en_consumption.next_tariff > 0)
          next_tariff = @current_en_consumption.next_tariff
        else
          next_tariff = @current_en_consumption.tariff 
        end
        
        next_cost = @consumer.en_bid.month_sum((Time.now.end_of_month + 1.day).month) * next_tariff * 1.2
      else
        next_cost = 0
      end
      # рассчитываем баланс
      @balance = calculate_balance(@en_payments, o_balance: @current_en_consumption.opening_balance,
                                                 prev_cost: prev_cons&.cost_val,
                                                 cur_cost: @current_en_consumption.cost_val,
                                                 next_cost: next_cost&.round(2),
                                                 money: @current_en_consumption.money)
      @current_balance = get_current_balance(@balance, o_balance: @current_en_consumption.opening_balance,
                                                       money: @current_en_consumption.money)
      # выбираем цену для счета
      if @current_en_consumption.tariff > 0
        # или тариф текщего месяца
        @current_tariff = @current_en_consumption.tariff
      else
        # или тариф ближайшего предыдущего месяца
        @current_tariff = @consumer.previous_en_consumption.order(:date).last&.tariff
      end
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
