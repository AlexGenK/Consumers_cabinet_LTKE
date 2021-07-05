class ChangePrecisionTariffToDTariff < ActiveRecord::Migration[6.0]
  def change
    change_column :d_tariffs, :class_one, :decimal, precision: 8, scale: 2
    change_column :d_tariffs, :class_two, :decimal, precision: 8, scale: 2
  end
end
