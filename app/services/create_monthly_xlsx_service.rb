class CreateMonthlyXlsxService
  require 'rubyXL'

  def self.call(consumer, monthly, daylies)
    workbook = RubyXL::Workbook.new
    workbook[0].add_cell(0, 0, "Погодинне споживання #{consumer.name} за #{monthly.date_cons.strftime('%m.%Y')}")

    (1..24).each do |i|
      workbook[0].add_cell(1, i+1, i)
    end

    line = 2
    daylies.each do |daily|
      workbook[0].add_cell(line, 0, daily.day_cons)
      workbook[0].add_cell(line, 1, daily.hourlies.sum(:w))

      hourlies = daily.hourlies.all.order(:hour_cons)
      column = 2
      hourlies.each do |hourly|
        workbook[0].add_cell(line, column, hourly.w)
        column += 1
      end

      line += 1
    end

    workbook
  end
end