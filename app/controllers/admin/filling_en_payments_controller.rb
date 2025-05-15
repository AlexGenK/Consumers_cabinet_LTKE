class Admin::FillingEnPaymentsController < ApplicationController
  require 'csv'
  include Admin::FillingEnPaymentsHelper
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
    file = params[:datafile]
    @imported = []
    begin
      csv_file = file.read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
      @imported = filling_from_file(csv_file)
    rescue
      flash[:alert] = 'Помилка при імпорті записів з файлу!'
    end
  end

  private

  def filling_from_file(csv_file)
    imported = []
    enps = {}
    csv = CSV.parse(csv_file, col_sep: ';')
    csv.each do |record|
      @consumer = Consumer.find_by(onec_id: to_1cid(record[0]), dog_num: record[1])
      if @consumer
        enp = [record[3], record[4], record[5]]
        if enps[@consumer.id].present?
          enps[@consumer.id] << enp     
        else
          enps[@consumer.id] = [enp]
        end
      end
    end

    enps.each do |key, item|
      @consumer = Consumer.find_by_id(key)
      if @consumer
        @consumer.en_payments&.destroy_all
        summary_percent = 0
        item.each do |enp|

          # reverse month notation
          month = case enp[2]
          when '1'
            '-1'
          when '-1'
            '1'
          else
            '0'
          end

          @consumer.en_payments.create(day: enp[0], percent: enp[1], month: month)
          summary_percent += enp[1].to_i
        end
        imported << "#{@consumer.name} #{summary_percent == 100 ? '' : ' - неповний графік!'}"
      end
    end

    imported
  end

  def filling_en_payments_params
    params.require(:filling_en_payments).permit(:datafile)
  end
end