require 'rufus-scheduler'
require 'net/ftp'
require 'csv'

include Admin::CsvHelper

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Task...

def filling_gas_from_file(csv_file)
  csv = CSV.parse(csv_file, col_sep: ';')
    csv.each do |record|
      @consumer = Consumer.find_by(onec_id: to_1cid(record[0]), dog_num: record[10])
      if @consumer
        @consumer.current_gas_consumption&.destroy

        opening_balance = -1*to_money(record[5])
        volume = (@consumer.gas_bid ? @consumer.gas_bid.month_sum(Time.now.month) : 0)
        tariff = to_tariff(record[6])
        cost = (volume * tariff).round(2)
        cost_val = (cost * 1.2).round(2)
        money = to_money(record[7])
        closing_balance = opening_balance - cost_val + money

        @consumer.create_current_gas_consumption(opening_balance: opening_balance,
                                                 volume:          volume,
                                                 tariff:          tariff,
                                                 cost:            cost,
                                                 cost_val:        cost_val,
                                                 money:           money,
                                                 closing_balance: closing_balance).save
      end
    end
end

def filling_en_from_file(csv_file)
  @imported = []
  csv = CSV.parse(csv_file, col_sep: ';')
    csv.each do |record|
      @consumer = Consumer.find_by(onec_id: to_1cid(record[0]), dog_num: record[10])
      if @consumer
        @consumer.current_en_consumption&.destroy

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
      end
    end
end

s.cron('20 1 * * *')  do
	Net::FTP.open(ENV['CONSUMERS_CABINET_LTKE_FTP_HOST'], 
                    port: ENV['CONSUMERS_CABINET_LTKE_FTP_PORT'],
                    username: ENV['CONSUMERS_CABINET_LTKE_FTP_USERNAME'],
                    password: ENV['CONSUMERS_CABINET_LTKE_FTP_PASSWORD'],) do |ftp|
        ftp.getbinaryfile('GazDay.csv', 'public/glocal.csv')
        ftp.getbinaryfile('ElectroDay.csv', 'public/elocal.csv')
        @file_gas = File.open('public/glocal.csv')
        @file_en = File.open('public/elocal.csv')
  end  

  csv_file = @file_gas.read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
  filling_gas_from_file(csv_file)
  csv_file = @file_en.read.encode('UTF-8', 'UTF-8', invalid: :replace, indef: :replace).gsub(/"/,'\'')
  filling_en_from_file(csv_file)
end
