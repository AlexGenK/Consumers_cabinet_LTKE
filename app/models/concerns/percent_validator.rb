class PercentValidator < ActiveModel::Validator
  def validate(record)
    if record.id
      allprc = EnPayment.where("consumer_id = ?", record.consumer_id).sum(:percent) - EnPayment.find(record.id).percent + record.percent
    else
      allprc = EnPayment.where("consumer_id = ?", record.consumer_id).sum(:percent) + record.percent
    end
    
    if allprc > 100
      record.errors.add(:active, "Операція неможлива. Планові платежі перевищили 100%")
    end
  end
end