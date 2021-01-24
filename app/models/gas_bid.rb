class GasBid < ApplicationRecord
  belongs_to :consumer

  MNT = ['','jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec']

  def month_sum(month)
    if month>0 && month<13
      return self.send("#{MNT[month]}")
    else
      return nil
    end
  end
end
