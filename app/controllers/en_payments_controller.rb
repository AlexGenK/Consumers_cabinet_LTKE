class EnPaymentsController < ApplicationController
  before_action :set_consumer
  before_action :set_en_payment, only: [:destroy, :edit, :update]

  def index
    @current_en_consumption = @consumer.current_en_consumption
    @en_payments = @consumer.en_payments.all.order(:day)
    @en_payment = @consumer.en_payments.new
  end

  def create
    @en_payment = @consumer.en_payments.new(en_payment_params)
    flash[:alert] = 'Неможливо створити платіж' unless @en_payment.save
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

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end

  def set_en_payment
    @en_payment = EnPayment.find(params[:id])
  end

  def en_payment_params
    params.require(:en_payment).permit(:day, :percent)
  end
	
end
