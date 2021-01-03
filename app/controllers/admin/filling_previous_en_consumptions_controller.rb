class Admin::FillingPreviousEnConsumptionsController < ApplicationController
  require 'csv'
  include Admin::FillingPreviousEnConsumptionsHelper
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
    @imported = 0
    csv = CSV.parse(csv_file, col_sep: ';')
      csv.each do |record|
        @consumer = Consumer.find_by(onec_id: to_1cid(record[0]))
        if @consumer
          delete_old(to_dog_en_date(record[1]))
          @consumer.previous_en_consumption.new(date:            to_dog_en_date(record[1]),
                                                opening_balance: record[2].to_f,
                                                power:           record[3].to_i,
                                                tariff:          record[4].to_f,
                                                cost:            record[5].to_f,
                                                cost_val:        record[6].to_f,
                                                money:           record[7].to_f,
                                                closing_balance: record[8].to_f).save
          @imported += 1
        end
      end
  end

  private

  def filling_previous_en_consumptions_params
    params.require(:filling_previous_en_consumptions).permit(:datafile)
  end

  def delete_old(date)
    old_consumptions = @consumer.previous_en_consumption.where(date: date)
    if old_consumptions
      old_consumptions.each do |consumption|
        consumption.destroy
      end
    end
  end
end
