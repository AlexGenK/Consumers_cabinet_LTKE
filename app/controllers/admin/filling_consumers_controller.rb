class Admin::FillingConsumersController < ApplicationController
	require 'csv'
  include Admin::FillingConsumersHelper
	skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
    @imported = []
    @not_imported = []
    begin
      csv_text = params[:datafile].read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
      csv = CSV.parse(csv_text, col_sep: ';')
      csv.each do |record|
        if Consumer.exists?(onec_id: to_1cid(record[0]), dog_num: record[7])
          @not_imported << "#{to_1cid(record[0])} - #{record[2]} - Дог. №#{record[7]}"
        else
          Consumer.new(name: record[2],
                      full_name: record[3],
                      edrpou: to_edrpou(record[1]),
                      onec_id: to_1cid(record[0]),
                      director_name: record[4],
                      dog_num: record[7],
                      dog_date: to_dog_date(record[6]),
                      address: record[9],
                      energy_consumer: record[8]=='Електроенергія',
                      gas_consumer: record[8]=='ГАЗ'
                      ).save
          @imported << "#{to_1cid(record[0])} - #{record[2]} - Дог. №#{record[7]}"
        end
      end
    rescue
      flash[:alert] = 'Помилка при імпорті записів з файлу!'
    end
  end

  private

  def filling_consumers_params
    params.require(:filling_consumers).permit(:datafile)
  end
end
