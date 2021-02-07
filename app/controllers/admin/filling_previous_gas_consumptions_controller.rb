class Admin::FillingPreviousGasConsumptionsController < ApplicationController
  require 'csv'
  include Admin::FillingPreviousGasConsumptionsHelper
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

  def destroy
    PreviousGasConsumption.all.destroy_all
    flash[:notice] = 'Всі записи щодо попереднього споживання газу видалені'
    redirect_to admin_filling_previous_gas_consumptions_path
  end


  def filling_from_file(csv_file)
    @imported = 0
    csv = CSV.parse(csv_file, col_sep: ';')
      csv.each do |record|
        @consumer = Consumer.find_by(onec_id: to_1cid(record[0]))
        if @consumer
          delete_old(record[2].to_date)
          @consumer.previous_gas_consumption.new(date:            record[2].to_date,
                                                 opening_balance: -1*record[4].to_f,
                                                 volume:          record[5].to_i,
                                                 tariff:          record[6].to_f,
                                                 cost:            record[7].to_f,
                                                 cost_val:        record[8].to_f,
                                                 money:           record[9].to_f,
                                                 closing_balance: -1*record[10].to_f).save
          @imported += 1
        end
      end
  end

  private

  def delete_old(date)
    old_consumptions = @consumer.previous_gas_consumption.where(date: date)
    if old_consumptions
      old_consumptions.each do |consumption|
        consumption.destroy
      end
    end
  end

  def filling_previous_gas_consumptions_params
    params.require(:filling_previous_gas_consumptions).permit(:datafile)
  end
end
