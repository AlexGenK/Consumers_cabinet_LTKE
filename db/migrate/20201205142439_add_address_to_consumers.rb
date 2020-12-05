class AddAddressToConsumers < ActiveRecord::Migration[6.0]
  def change
    add_column :consumers, :address, :string
  end
end
