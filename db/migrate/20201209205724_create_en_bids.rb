class CreateEnBids < ActiveRecord::Migration[6.0]
  def change
    create_table :en_bids do |t|
      t.integer :jan_a_1
      t.integer :jan_a_2
      t.integer :jan_b_1
      t.integer :jan_b_2

      t.integer :feb_a_1
      t.integer :feb_a_2
      t.integer :feb_b_1
      t.integer :feb_b_2

      t.integer :mar_a_1
      t.integer :mar_a_2
      t.integer :mar_b_1
      t.integer :mar_b_2

      t.integer :apr_a_1
      t.integer :apr_a_2
      t.integer :apr_b_1
      t.integer :apr_b_2

      t.integer :may_a_1
      t.integer :may_a_2
      t.integer :may_b_1
      t.integer :may_b_2

      t.integer :jun_a_1
      t.integer :jun_a_2
      t.integer :jun_b_1
      t.integer :jun_b_2

      t.integer :jul_a_1
      t.integer :jul_a_2
      t.integer :jul_b_1
      t.integer :jul_b_2

      t.integer :aug_a_1
      t.integer :aug_a_2
      t.integer :aug_b_1
      t.integer :aug_b_2

      t.integer :sep_a_1
      t.integer :sep_a_2
      t.integer :sep_b_1
      t.integer :sep_b_2

      t.integer :okt_a_1
      t.integer :okt_a_2
      t.integer :okt_b_1
      t.integer :okt_b_2

      t.integer :nov_a_1
      t.integer :nov_a_2
      t.integer :nov_b_1
      t.integer :nov_b_2

      t.integer :dec_a_1
      t.integer :dec_a_2
      t.integer :dec_b_1
      t.integer :dec_b_2
      
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
