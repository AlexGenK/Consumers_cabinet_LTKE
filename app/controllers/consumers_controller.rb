class ConsumersController < ApplicationController
  before_action :set_consumer, only: [:edit, :update, :destroy]
  before_action :set_users_list, only: [:new, :edit, :create]
  before_action :detect_invalid_user, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def index
    if current_user.admin_role?
      @consumers=Consumer.order(:name)
    elsif current_user.manager_role?
      @consumers=Consumer.where('manager_en_username = ?', current_user.name).
                or(Consumer.where('manager_gas_username = ?', current_user.name)).
                order(:name)
    elsif current_user.client_role?
      @consumers = Consumer.where('client_username = ?', current_user.name) + current_user.consumers
      @consumers = @consumers.sort_by(&:name)
    end
  end

  def new
    @consumer = Consumer.new
    @consumer.manager_en_username = current_user.name
    @consumer.manager_gas_username = current_user.name
  end

  def create
    @consumer = Consumer.new(consumer_params)
    if @consumer.save
      params[:add_clients_username]&.each do |username|
        @consumer.users << User.find_by(name: username)
      end
      redirect_to consumers_path, notice: "Споживач #{@consumer.name} успішно створений"
    else
      flash[:alert] = 'Неможливо створити споживача'
      render :new
    end
  end

  def edit
  end

  def update
    if @consumer.update(consumer_params)

      @consumer.users.clear
      params[:add_clients_username]&.each do |username|
        @consumer.users << User.find_by(name: username)
      end  

      redirect_to consumers_path, notice: "Споживач #{@consumer.name} успішно відредагований"
    else
      flash[:alert] = 'Неможливо відредагувати споживача'
      render :edit
    end
  end

  def destroy
    @consumer.destroy
    redirect_to consumers_path
  end

  private

  def consumer_params
    if current_user.admin_role? || current_user.manager_role?
      params.require(:consumer).permit(:name, :full_name, :edrpou, :onec_id,
                                       :director_name, :director_phone, :director_mail,
                                       :engineer_name, :engineer_phone, :engineer_mail,
                                       :accountant_name, :accountant_phone, :accountant_mail,
                                       :dog_num, :dog_date,
                                       :dog_gas_num, :dog_gas_date,
                                       :energy_consumer, :gas_consumer, :has_hourly,
                                       :manager_en_username, :manager_gas_username,
                                       :client_username, :address, :add_clients_username, :eic)
    else
      params.require(:consumer).permit(:director_name, :director_phone, :director_mail,
                                       :engineer_name, :engineer_phone, :engineer_mail,
                                       :accountant_name, :accountant_phone, :accountant_mail)
    end
  end

  def set_consumer
    @consumer = Consumer.find(params[:id])
  end

  def set_users_list
    @managers = User.where("manager_role").order(:name).collect(&:name)
    @clients = User.where("client_role").order(:name).collect(&:name)
    @add_clients = []
    @consumer.users.each {|user| @add_clients << user.name } if @consumer != nil
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
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
end
