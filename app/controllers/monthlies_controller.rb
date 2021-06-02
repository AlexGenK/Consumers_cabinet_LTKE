class MonthliesController < ApplicationController
  before_action :set_consumer
  before_action :detect_invalid_user
  load_and_authorize_resource
  
  def index
    @monthlies = @consumer.monthlies.all.order(date_cons: :desc)
    @monthly = @monthlies.first
    redirect_to consumer_monthly_path(@consumer, @monthly) if @monthly
  end

  def show
    @monthlies = @consumer.monthlies.all.order(date_cons: :desc)
    @monthly = Monthly.find(params[:id])
    @dailies = @monthly.dailies.all.order(:day_cons)
  end

  def create
    @monthly = ParseMonthlyService.call(params[:datafile].read)
    CreateMDHConsumptionQuery.call(params[:date].to_date.change(day: 1), @monthly, @consumer)
    redirect_to consumer_monthlies_path(@consumer), notice: "Погодинне споживання для #{@consumer.name} імпортовано успішно"
  end

  def selector
    @monthly = Monthly.find(params[:monthly_id])
    redirect_to consumer_monthly_path(@consumer, @monthly)
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = (params[:cab]=='gas' ? User.find_by(name: @consumer.manager_gas_username) : User.find_by(name: @consumer.manager_en_username))
    @client = User.find_by(name: @consumer.client_username)
  end
  
  def message_params
      params.require(:monthlies).permit(:date, :file)
  end
  
  def detect_invalid_user
      unless current_user.admin_role?
          if current_user.manager_role?
          denied_action if (@consumer.manager_en_username != current_user.name) &&
                              (@consumer.manager_gas_username != current_user.name)
          elsif current_user.client_role?
          consumers = @consumer.users.map{|n| n.name}
          consumers << @consumer.client_username
          denied_action unless consumers.include?(current_user.name)
          end
      end
  end

  def denied_action
      redirect_to :consumers, alert: "Спроба отримати доступ до запітив споживача, що Вам не належить або не існує"
  end
end
