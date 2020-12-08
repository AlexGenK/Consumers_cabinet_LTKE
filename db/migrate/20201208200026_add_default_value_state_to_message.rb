class AddDefaultValueStateToMessage < ActiveRecord::Migration[6.0]
  def change
  	change_column :messages, :state, :integer, default: 0
  end
end
