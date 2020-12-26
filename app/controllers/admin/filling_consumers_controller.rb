class Admin::FillingConsumersController < ApplicationController
	require 'csv'
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
        if Consumer.exists?(onec_id: to_1cid(record[0]))
          @not_imported << "#{to_1cid(record[0])} - #{record[2]}"
        else
          Consumer.new(name: record[2],
                      full_name: record[3],
                      edrpou: to_edrpou(record[1]),
                      onec_id: to_1cid(record[0]),
                      director_name: "#{record[4]} #{record[5]} #{record[6]}",
                      dog_en_num: to_dog_en_num(record[7]),
                      dog_en_date: to_dog_en_date(record[8]),
                      address: record[9],
                      energy_consumer: true
                      ).save
          @imported << "#{to_1cid(record[0])} - #{record[2]}"
        end
      end
    rescue
      flash[:alert] = 'Помилка при імпорті записів з файлу!'
    end
  end

  private

  def to_1cid(item)
    id = item.to_i
    id == 0 ? 10000 + item[3..-1].to_i : id
  end

  def to_edrpou(item)
    item.rjust(8, '0') 
  end

  def to_dog_en_num(item)
    item =~ /Договір №(.*) від/ ? Regexp.last_match[1].strip : nil
  end

  def to_dog_en_date(item)
    item == nil ? nil : Date.strptime(item, '%Y.%m.%d')
  end

  def filling_consumers_params
    params.require(:filling_consumers).permit(:datafile)
  end
end
