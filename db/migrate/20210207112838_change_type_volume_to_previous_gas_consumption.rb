class ChangeTypeVolumeToPreviousGasConsumption < ActiveRecord::Migration[6.0]
  def change
  	change_column :previous_gas_consumptions, :volume, :decimal, precision: 13, scale: 3
  end
end
