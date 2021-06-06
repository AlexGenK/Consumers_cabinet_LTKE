class CreateHourlies < ActiveRecord::Migration[6.0]
  def change
    create_table :hourlies do |t|
      t.integer :hour_cons
      t.decimal :w, precision: 8, scale: 2
      t.references :daily, null: false, foreign_key: true

      t.timestamps
    end
  end
end
