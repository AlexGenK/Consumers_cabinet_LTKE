class AddNextTariffToCurrentEnConsumptions < ActiveRecord::Migration[6.0]
  def change
  	add_column :current_en_consumptions, :next_tariff, :decimal, precision: 13, scale: 8
  end
end
