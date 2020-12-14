class CreateGasBids < ActiveRecord::Migration[6.0]
  def change
    create_table :gas_bids do |t|
      t.integer :jan, default: 0
      t.integer :feb, default: 0
      t.integer :mar, default: 0
      t.integer :apr, default: 0
      t.integer :may, default: 0
      t.integer :jun, default: 0
      t.integer :jul, default: 0
      t.integer :aug, default: 0
      t.integer :sep, default: 0
      t.integer :okt, default: 0
      t.integer :nov, default: 0
      t.integer :dec, default: 0
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
