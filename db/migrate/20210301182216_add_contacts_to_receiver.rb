class AddContactsToReceiver < ActiveRecord::Migration[6.0]
  def change
  	add_column :receivers, :buh_name, :string
  	add_column :receivers, :buh_phone, :string
  	add_column :receivers, :buh_mail, :string

		add_column :receivers, :dog_name, :string
  	add_column :receivers, :dog_phone, :string
  	add_column :receivers, :dog_mail, :string

  	add_column :receivers, :teh_name, :string
  	add_column :receivers, :teh_phone, :string
  	add_column :receivers, :teh_mail, :string

  	add_column :receivers, :com_name, :string
  	add_column :receivers, :com_phone, :string
  	add_column :receivers, :com_mail, :string
  end
end
