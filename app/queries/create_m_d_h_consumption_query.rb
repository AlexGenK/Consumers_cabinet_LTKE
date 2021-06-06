class CreateMDHConsumptionQuery
    def self.call(date, cons_array, consumer)
        @prev_monthly = consumer.monthlies.find_by(date_cons: date)
        @prev_monthly.destroy if @prev_monthly
        @monthly = consumer.monthlies.new(date_cons: date)
        @monthly.save
        cons_array.each do |day|
            @daily = @monthly.dailies.new(day_cons: day[0])
            @daily.save
            day[1..-1].each_with_index do |w, i|
                @hourly= @daily.hourlies.new(hour_cons: i+1, w: w)
                @hourly.save
            end
        end
    end
end