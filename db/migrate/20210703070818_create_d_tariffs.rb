class CreateDTariffs < ActiveRecord::Migration[6.0]
  def change
    create_table :d_tariffs do |t|
      t.decimal :class_one
      t.decimal :class_two
      t.date :start_date
      t.string :decree
      t.date :decree_date
      t.references :d_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
