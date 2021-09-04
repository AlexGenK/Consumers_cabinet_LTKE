class AddEmailsToReceiver < ActiveRecord::Migration[6.0]
  def change
    add_column :receivers, :adjustment_email, :string
    add_column :receivers, :message_email, :string
  end
end
