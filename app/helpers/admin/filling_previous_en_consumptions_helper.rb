module Admin::FillingPreviousEnConsumptionsHelper
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
end
