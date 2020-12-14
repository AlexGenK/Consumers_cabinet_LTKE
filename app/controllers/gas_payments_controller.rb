class GasPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_gas_payment, only: [:destroy, :edit, :update]

  def index
    @current_gas_consumption = @consumer.current_gas_consumption
    @gas_payments = @consumer.gas_payments.all.order(:day)
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

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_gas_payment
    @gas_payment = GasPayment.find(params[:id])
  end

  def gas_payment_params
    params.require(:gas_payment).permit(:day, :percent)
  end
end
