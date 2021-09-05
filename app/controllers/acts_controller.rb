class ActsController < ApplicationController
  before_action :set_consumer
  before_action :detect_invalid_user

  def index
    @out_documents = @vchasno_client.out_docs(@consumer.edrpou)['documents']
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @vchasno_client = Vchasno::V2::Client.new(ENV['CONSUMERS_CABINET_LTKE_API_TOKEN'])
    @manager = User.find_by(name: @consumer.manager_en_username)
    @client = User.find_by(name: @consumer.client_username)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_gas_username != current_user.name
      elsif current_user.client_role?
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
