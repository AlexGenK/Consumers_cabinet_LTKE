class GetDailiesConsumptionsQuery
  def self.call(scope, day_begin, day_end)
    dailies_graph = []
    (day_begin..day_end).each do |day|
      daily = scope.where(day_cons: day)[0]
      if daily
        hourlies = daily.hourlies.all.order(:hour_cons)
        dailies_graph << {:name => "#{day} #{I18n.t('date.month_names')[daily.monthly.date_cons.month]}", :data => hourlies.pluck(:hour_cons, :w)}
      end
    end
    dailies_graph
  end
end
