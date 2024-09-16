class AddEicToConsumers < ActiveRecord::Migration[6.0]
  def change
    add_column :consumers, :eic, :text
  end
end
