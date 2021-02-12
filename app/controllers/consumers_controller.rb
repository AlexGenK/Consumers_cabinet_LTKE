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
      @consumers=Consumer.where('client_username = ?', current_user.name).order(:name)
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
    params.require(:consumer).permit(:name, :full_name, :edrpou, :onec_id,
                                     :director_name, :director_phone, :director_mail,
                                     :engineer_name, :engineer_phone, :engineer_mail,
                                     :accountant_name, :accountant_phone, :accountant_mail,
                                     :dog_num, :dog_date,
                                     :dog_gas_num, :dog_gas_date,
                                     :energy_consumer, :gas_consumer,
                                     :manager_en_username, :manager_gas_username,
                                     :client_username, :address)
  end

  def set_consumer
    @consumer = Consumer.find(params[:id])
  end

  def set_users_list
    @managers = User.where("manager_role").order(:name).collect(&:name)
    @clients = User.where("client_role").order(:name).collect(&:name)
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if (@consumer.manager_en_username != current_user.name) &&
                         (@consumer.manager_gas_username != current_user.name)
      elsif current_user.client_role?
        denied_action if @consumer.client_username != current_user.name
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
end
