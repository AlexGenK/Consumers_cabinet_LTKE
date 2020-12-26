class EnBidsController < ApplicationController
  before_action :set_consumer
  before_action :set_en_bid
  load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    if @en_bid.update(en_bid_params)
      flash[:alert] = nil
      redirect_to consumer_en_bid_path(@consumer)
    else
      flash[:alert] = 'Неможливо відредагувати заявку'
      render :edit
    end
  end

  private

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
    @manager = User.find_by(name: @consumer.manager_en_username)
  end

  def set_en_bid
    @en_bid = Consumer.find(params[:consumer_id]).en_bid
    @en_bid ||= @consumer.create_en_bid
  end

  def en_bid_params
    params.require(:en_bid).permit(:jan_a_1, :jan_b_1, :jan_a_2, :jan_b_2,
                                   :feb_a_1, :feb_b_1, :feb_a_2, :feb_b_2,
                                   :mar_a_1, :mar_b_1, :mar_a_2, :mar_b_2,
                                   :apr_a_1, :apr_b_1, :apr_a_2, :apr_b_2,
                                   :may_a_1, :may_b_1, :may_a_2, :may_b_2,
                                   :jun_a_1, :jun_b_1, :jun_a_2, :jun_b_2,
                                   :jul_a_1, :jul_b_1, :jul_a_2, :jul_b_2,
                                   :aug_a_1, :aug_b_1, :aug_a_2, :aug_b_2,
                                   :sep_a_1, :sep_b_1, :sep_a_2, :sep_b_2,
                                   :okt_a_1, :okt_b_1, :okt_a_2, :okt_b_2,
                                   :nov_a_1, :nov_b_1, :nov_a_2, :nov_b_2,
                                   :dec_a_1, :dec_b_1, :dec_a_2, :dec_b_2)
  end
end
