class CreateCurrentEnConsumptions < ActiveRecord::Migration[6.0]
  def change
    create_table :current_en_consumptions do |t|
      t.date :date
      t.decimal :opening_balance, precision: 13, scale: 2
      t.integer :power
      t.decimal :tariff, precision: 10, scale: 5
      t.decimal :cost, precision: 13, scale: 2
      t.decimal :cost_val, precision: 13, scale: 2
      t.decimal :money, precision: 13, scale: 2
      t.decimal :closing_balance, precision: 13, scale: 2
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
