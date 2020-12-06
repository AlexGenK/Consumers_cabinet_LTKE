class ConsumersController < ApplicationController

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

  def destroy
    Consumer.find(params[:id]).destroy
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

end
