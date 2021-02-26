class Admin::FillingCurrentEnConsumptionsController < ApplicationController
  require 'csv'
  require 'net/ftp'
  include Admin::FillingCurrentEnConsumptionsHelper
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
        ftp.getbinaryfile('ElectroDay.csv', 'public/local.csv')
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

  def filling_from_file(csv_file)
    @imported = []
    csv = CSV.parse(csv_file, col_sep: ';')
      csv.each do |record|
        @consumer = Consumer.find_by(onec_id: to_1cid(record[0]), dog_num: record[10])
        if @consumer
          delete_old

          opening_balance = -1*to_money(record[5])
          power = (@consumer.en_bid ? @consumer.en_bid.month_sum(Time.now.month) : 0)
          tariff = to_tariff(record[6])
          cost = (power * tariff).round(2)
          cost_val = (cost * 1.2).round(2)
          money = to_money(record[7])
          closing_balance = opening_balance - cost_val + money

          @consumer.create_current_en_consumption(opening_balance: opening_balance,
                                               		power:           power,
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
  	@consumer.current_en_consumption&.destroy
  end

  def filling_current_en_consumptions_params
    params.require(:filling_current_en_consumptions).permit(:datafile)
  end
end
