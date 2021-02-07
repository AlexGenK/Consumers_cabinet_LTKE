module Admin::CsvHelper

  def to_number_string(item)
    (item == nil) || (item == '')  ? '0' : item.gsub(/,/, '.').gsub(/[^0-9.-]/, '')
  end

  def to_1cid(item)
    item = to_number_string(item)
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

  def to_money(item)
    (item == nil) || (item == '') ? 0 : to_number_string(item).to_f.round(2)
  end

  def to_tariff(item)
    (item == nil) || (item == '') ? 0 : ((to_number_string(item).to_f)/1000).round(8)
  end

  def to_kvt(item)
    (item == nil) || (item == '') ? 0 : (to_number_string(item).to_f*1000).to_i
  end

  def to_m3(item)
    (item == nil) || (item == '') ? 0 : to_number_string(item).to_f*1000
  end
end