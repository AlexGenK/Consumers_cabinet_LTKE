class AddDefaultValueOperationalToDCompany < ActiveRecord::Migration[6.0]
  def change
    change_column :d_companies, :operational, :boolean, default: true
  end
end
