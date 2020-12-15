class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.string :name
      t.string :address
      t.integer :edrpou
      t.bigint :ipn
      t.string :account
      t.string :bank

      t.timestamps
    end

    reversible do |change|
      change.up do
        # Initialize first reciever:
        Receiver.create! do |r|
          r.name       = 'Big Company'
        end
      end
    end
  end
end
