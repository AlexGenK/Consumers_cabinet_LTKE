class CreateConsumersUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :consumers_users, id: false do |t|
      t.belongs_to :consuner
      t.belongs_to :user
    end
  end
end
