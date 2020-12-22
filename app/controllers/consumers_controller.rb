class ConsumersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_consumer, only: [:edit, :update, :destroy]
  before_action :set_users_list, only: [:new, :edit, :create]

	def index
		@consumers=Consumer.order(:name)
	end

	def new
    @consumer = Consumer.new
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
                                      :director_name, :engineer_name,
                                      :dog_en_num, :dog_en_date,
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
end
