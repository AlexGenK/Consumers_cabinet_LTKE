class AddNextTariffToCurrentGasConsumptions < ActiveRecord::Migration[6.0]
  def change
  	add_column :current_gas_consumptions, :next_tariff, :decimal, precision: 10, scale: 5
  end
end
