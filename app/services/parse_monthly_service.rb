class ParseMonthlyService
    require 'rubyXL'
  
    def self.call(file)
        workbook = RubyXL::Parser.parse_buffer(file)
        arr_montly=[]
        worksheet = workbook[0]
        row_number = 1        
        day = extract_day(worksheet, row_number) 
        while day>0 && day<32 && row_number<32 
            col_number = 2
            arr_daily = []
            arr_daily << day
            24.times do
                arr_daily << extract_w(worksheet, row_number, col_number)
                col_number += 1
            end
            arr_montly << arr_daily
            row_number += 1
            day = extract_day(worksheet, row_number)
        end
        arr_montly
    end

    private

    def self.extract_day(worksheet, i)
        row = worksheet[i]
        return 0 if row == nil 
        return 0 if row[0] == nil 
        row[0].value&.to_i
    end

    def self.extract_w(worksheet, i, j)
        worksheet[i][j].value&.to_f
    end
end