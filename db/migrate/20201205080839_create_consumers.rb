class CreateConsumers < ActiveRecord::Migration[6.0]
  def change
    create_table :consumers do |t|
      t.string :name
      t.text :full_name
      t.string :edrpou
      t.integer :onec_id
      t.string :director_name
      t.string :engineer_name
      t.string :dog_en_num
      t.date :dog_en_date
      t.string :dog_gas_num
      t.date :dog_gas_date
      t.boolean :energy_consumer
      t.boolean :gas_consumer
      t.string :client_username
      t.string :manager_en_username
      t.string :manager_gas_username

      t.timestamps
    end
  end
end
