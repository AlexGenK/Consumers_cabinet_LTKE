class CreateMonthlies < ActiveRecord::Migration[6.0]
  def change
    create_table :monthlies do |t|
      t.date :date_cons
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
