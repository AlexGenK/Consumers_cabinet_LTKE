class CreateEnCertificates < ActiveRecord::Migration[6.0]
  def change
    create_table :en_certificates do |t|
      t.belongs_to :consumer, index: true
      t.date :date

      t.timestamps
    end
  end
end
