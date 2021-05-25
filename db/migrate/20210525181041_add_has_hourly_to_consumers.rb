class AddHasHourlyToConsumers < ActiveRecord::Migration[6.0]
  def change
    add_column :consumers, :has_hourly, :boolean, default: false
  end
end
