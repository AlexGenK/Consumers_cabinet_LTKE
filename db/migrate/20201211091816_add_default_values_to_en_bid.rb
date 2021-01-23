class AddDefaultValuesToEnBid < ActiveRecord::Migration[6.0]
  def change
  	change_column :en_bids, :jan_a_1, :integer, default: 0
      change_column :en_bids, :jan_a_2, :integer, default: 0
      change_column :en_bids, :jan_b_1, :integer, default: 0
      change_column :en_bids, :jan_b_2, :integer, default: 0

      change_column :en_bids, :feb_a_1, :integer, default: 0
      change_column :en_bids, :feb_a_2, :integer, default: 0
      change_column :en_bids, :feb_b_1, :integer, default: 0
      change_column :en_bids, :feb_b_2, :integer, default: 0

      change_column :en_bids, :mar_a_1, :integer, default: 0
      change_column :en_bids, :mar_a_2, :integer, default: 0
      change_column :en_bids, :mar_b_1, :integer, default: 0
      change_column :en_bids, :mar_b_2, :integer, default: 0

      change_column :en_bids, :apr_a_1, :integer, default: 0
      change_column :en_bids, :apr_a_2, :integer, default: 0
      change_column :en_bids, :apr_b_1, :integer, default: 0
      change_column :en_bids, :apr_b_2, :integer, default: 0

      change_column :en_bids, :may_a_1, :integer, default: 0
      change_column :en_bids, :may_a_2, :integer, default: 0
      change_column :en_bids, :may_b_1, :integer, default: 0
      change_column :en_bids, :may_b_2, :integer, default: 0

      change_column :en_bids, :jun_a_1, :integer, default: 0
      change_column :en_bids, :jun_a_2, :integer, default: 0
      change_column :en_bids, :jun_b_1, :integer, default: 0
      change_column :en_bids, :jun_b_2, :integer, default: 0

      change_column :en_bids, :jul_a_1, :integer, default: 0
      change_column :en_bids, :jul_a_2, :integer, default: 0
      change_column :en_bids, :jul_b_1, :integer, default: 0
      change_column :en_bids, :jul_b_2, :integer, default: 0

      change_column :en_bids, :aug_a_1, :integer, default: 0
      change_column :en_bids, :aug_a_2, :integer, default: 0
      change_column :en_bids, :aug_b_1, :integer, default: 0
      change_column :en_bids, :aug_b_2, :integer, default: 0

      change_column :en_bids, :sep_a_1, :integer, default: 0
      change_column :en_bids, :sep_a_2, :integer, default: 0
      change_column :en_bids, :sep_b_1, :integer, default: 0
      change_column :en_bids, :sep_b_2, :integer, default: 0

      change_column :en_bids, :okt_a_1, :integer, default: 0
      change_column :en_bids, :okt_a_2, :integer, default: 0
      change_column :en_bids, :okt_b_1, :integer, default: 0
      change_column :en_bids, :okt_b_2, :integer, default: 0

      change_column :en_bids, :nov_a_1, :integer, default: 0
      change_column :en_bids, :nov_a_2, :integer, default: 0
      change_column :en_bids, :nov_b_1, :integer, default: 0
      change_column :en_bids, :nov_b_2, :integer, default: 0

      change_column :en_bids, :dec_a_1, :integer, default: 0
      change_column :en_bids, :dec_a_2, :integer, default: 0
      change_column :en_bids, :dec_b_1, :integer, default: 0
      change_column :en_bids, :dec_b_2, :integer, default: 0
  end
end
