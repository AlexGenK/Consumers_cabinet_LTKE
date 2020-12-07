class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :text
      t.text :comment
      t.integer :state
      t.boolean :gas
      t.boolean :energy
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
