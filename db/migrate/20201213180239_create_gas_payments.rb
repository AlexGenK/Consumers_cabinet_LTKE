class CreateGasPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :gas_payments do |t|
      t.integer :day
      t.integer :percent
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
