class CreateDCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :d_companies do |t|
      t.string :name
      t.boolean :operational

      t.timestamps
    end
  end
end
