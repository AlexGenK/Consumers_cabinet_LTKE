class AddContactsToConsumer < ActiveRecord::Migration[6.0]
  def change
  	add_column :consumers, :director_phone, :string
  	add_column :consumers, :director_mail, :string

  	add_column :consumers, :engineer_phone, :string
  	add_column :consumers, :engineer_mail, :string

  	add_column :consumers, :accountant_name, :string
  	add_column :consumers, :accountant_phone, :string
  	add_column :consumers, :accountant_mail, :string
  end
end
