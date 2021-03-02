class AddGasAccountToReceiver < ActiveRecord::Migration[6.0]
  def change
  	add_column :receivers, :account_gas, :string
  	add_column :receivers, :bank_gas, :string
  end
end
