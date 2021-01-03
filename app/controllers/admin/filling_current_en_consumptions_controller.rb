class Admin::FillingCurrentEnConsumptionsController < ApplicationController
  require 'csv'
  include Admin::FillingCurrentEnConsumptionsHelper
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
          @consumer.create_current_en_consumption(opening_balance: record[1].to_f,
                                               		power:           record[2].to_i,
                                               		tariff:          record[3].to_f,
                                               		cost:            record[4].to_f,
                                               		cost_val:        record[5].to_f,
                                               		money:           record[6].to_f,
                                               		closing_balance: record[7].to_f).save
          @imported << "#{@consumer.onec_id} - #{@consumer.name}"
        end
      end
  end

  private

  def delete_old
  	@consumer.current_en_consumption&.destroy
  end

  def filling_current_en_consumptions_params
    params.require(:filling_current_en_consumptions).permit(:datafile)
  end
end
