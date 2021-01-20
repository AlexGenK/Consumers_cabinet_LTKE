class CreateEnAdjustments < ActiveRecord::Migration[6.0]
  def change
    create_table :en_adjustments do |t|
      t.integer :month
      t.bigint :value
      t.text :comment
      t.integer :state, default: 0
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
