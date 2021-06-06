class DailiesController < ApplicationController
  before_action :set_monthly
  before_action :detect_invalid_user
  load_and_authorize_resource

  def index
    @day_begin = params[:day_begin].to_i
    @day_end = params[:day_end].to_i
    @day_begin, @day_end = @day_end, @day_begin if @day_begin > @day_end
    scope = @monthly.dailies.all
    @dailies_graph = GetDailiesConsumptionsQuery.call(scope, @day_begin, @day_end)
  end

  private

  def set_monthly
    @monthly = Monthly.find(params[:monthly_id])
    @consumer = @monthly.consumer
    @manager = (params[:cab]=='gas' ? User.find_by(name: @consumer.manager_gas_username) : User.find_by(name: @consumer.manager_en_username))
    @client = User.find_by(name: @consumer.client_username)
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
      redirect_to :consumers, alert: "Спроба отримати доступ до споживання споживача, що Вам не належить або не існує"
  end
end
