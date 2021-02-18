class Admin::FillingPreviousEnConsumptionsController < ApplicationController
  require 'csv'
  require 'net/ftp'
  include Admin::FillingPreviousEnConsumptionsHelper
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
    if params[:datafile]
      file = params[:datafile]
    else
      Net::FTP.open(ENV['CONSUMERS_CABINET_LTKE_FTP_HOST'], 
                    port: ENV['CONSUMERS_CABINET_LTKE_FTP_PORT'],
                    username: ENV['CONSUMERS_CABINET_LTKE_FTP_USERNAME'],
                    password: ENV['CONSUMERS_CABINET_LTKE_FTP_PASSWORD'],) do |ftp|
        ftp.getbinaryfile('Electro.csv', 'public/local.csv')
        file = File.open('public/local.csv')
      end
    end

    begin
      csv_file = file.read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
      filling_from_file(csv_file)
    rescue
      flash[:alert] = 'Помилка при імпорті записів з файлу!'
    end
  end

  def destroy
    PreviousEnConsumption.all.destroy_all
    flash[:notice] = 'Всі записи щодо попереднього споживання електроенергії видалені'
    redirect_to admin_filling_previous_en_consumptions_path
  end

  def filling_from_file(csv_file)
    @imported = 0
    csv = CSV.parse(csv_file, col_sep: ';')
      csv.each do |record|
        @consumer = Consumer.find_by(onec_id: to_1cid(record[0]), dog_num: record[13])
        if @consumer
          delete_old(record[2].to_date)
          @consumer.previous_en_consumption.new(date:            (record[2].to_date),
                                                opening_balance: -1*to_money(record[5]),
                                                power:           to_kvt(record[6]),
                                                tariff:          to_tariff(record[7]),
                                                cost:            to_money(record[8]),
                                                cost_val:        to_money(record[9]),
                                                money:           to_money(record[10]),
                                                closing_balance: -1*to_money(record[11])).save
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
