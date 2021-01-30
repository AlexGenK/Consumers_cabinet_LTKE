class ChangePrecisionTariffToPreviousEnConsumption < ActiveRecord::Migration[6.0]
  def change
  	change_column :previous_en_consumptions, :tariff, :decimal, precision: 13, scale: 8
  end
end
