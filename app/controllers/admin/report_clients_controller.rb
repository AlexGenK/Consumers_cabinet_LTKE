class Admin::ReportClientsController < ApplicationController
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def show
    @en_consumers_user = []
    @gas_consumers_user = []

    Consumer.where(energy_consumer: true).order(:name).each do |consumer|
      manager = User.find_by(name: consumer.manager_en_username)
      client = User.find_by(name: consumer.client_username)
      @en_consumers_user << [consumer.name, consumer.edrpou, consumer.dog_num, consumer.dog_date, client&.name, manager&.name]
    end

    Consumer.where(gas_consumer: true).order(:name).each do |consumer|
      manager = User.find_by(name: consumer.manager_gas_username)
      client = User.find_by(name: consumer.client_username)
      @gas_consumers_user << [consumer.name, consumer.edrpou, consumer.dog_num, consumer.dog_date, client&.name, manager&.name]
    end
  end
end
