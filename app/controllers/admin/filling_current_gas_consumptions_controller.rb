class Admin::FillingCurrentGasConsumptionsController < ApplicationController
	require 'csv'
  include Admin::FillingCurrentGasConsumptionsHelper
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
    begin
      csv_file = params[:datafile].read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
      filling_from_file(csv_file)
    rescue
      flash[:alert] = 'Помилка при імпорті записів з файлу!'
    end
  end

  def filling_from_file(csv_file)
    @imported = []
    csv = CSV.parse(csv_file, col_sep: ';')
      csv.each do |record|
        @consumer = Consumer.find_by(onec_id: to_1cid(record[0]))
        if @consumer
          delete_old

          opening_balance = -1*to_money(record[4])
          volume = (@consumer.gas_bid ? @consumer.gas_bid.month_sum(Time.now.month) : 0)
          tariff = to_tariff(record[5])
          cost = (volume * tariff).round(2)
          cost_val = (cost * 1.2).round(2)
          money = to_money(record[6])
          closing_balance = opening_balance - cost_val + money

          @consumer.create_current_gas_consumption(opening_balance: opening_balance,
                                                   volume:          volume,
                                                   tariff:          tariff,
                                                   cost:            cost,
                                                   cost_val:        cost_val,
                                                   money:           money,
                                                   closing_balance: closing_balance).save
          @imported << "#{@consumer.onec_id} - #{@consumer.name}"
        end
      end
  end

  private

  def delete_old
    @consumer.current_gas_consumption&.destroy
  end

  def filling_current_gas_consumptions_params
    params.require(:filling_current_gas_consumptions).permit(:datafile)
  end
end
