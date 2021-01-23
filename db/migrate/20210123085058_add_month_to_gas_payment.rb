class AddMonthToGasPayment < ActiveRecord::Migration[6.0]
  def change
  	add_column :gas_payments, :month, :integer, default: 0
  end
end
