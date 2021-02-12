class RenameDogEnColumnFromConsumers < ActiveRecord::Migration[6.0]
  def change
  	rename_column :consumers, :dog_en_date, :dog_date
  	rename_column :consumers, :dog_en_num, :dog_num
  end
end
