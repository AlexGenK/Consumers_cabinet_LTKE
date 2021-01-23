class AddMonthToEnPayment < ActiveRecord::Migration[6.0]
  def change
  	add_column :en_payments, :month, :integer, default: 0
  end
end
