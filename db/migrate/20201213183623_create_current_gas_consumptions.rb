class CreateCurrentGasConsumptions < ActiveRecord::Migration[6.0]
  def change
    create_table :current_gas_consumptions do |t|
      t.date :date
      t.decimal :opening_balance
      t.integer :volume
      t.decimal :tariff
      t.decimal :cost
      t.decimal :cost_val
      t.decimal :money
      t.decimal :closing_balance
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
