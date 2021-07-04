class GetCurrentDTariffsQuery
  def self.call(scope, date)
    t = []
    scope.each do |company|
      tariffs = company.d_tariffs.where(["start_date < ?", date])
      last_tariff = tariffs.order(:start_date).last
      t << last_tariff if last_tariff != nil
    end
    t.size > 0 ? t : nil
  end
end