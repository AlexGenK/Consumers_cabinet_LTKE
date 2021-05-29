class CreateDailies < ActiveRecord::Migration[6.0]
  def change
    create_table :dailies do |t|
      t.integer :day_cons
      t.references :monthly, null: false, foreign_key: true

      t.timestamps
    end
  end
end
