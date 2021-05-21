class EnBidsController < ApplicationController
  before_action :set_consumer
  before_action :set_en_bid
  before_action :detect_invalid_user
  rescue_from ActiveRecord::RecordNotFound, with: :denied_action
  load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    if @en_bid.update(en_bid_params)
      flash[:alert] = nil
      recalc_cur_cons
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
    @client = User.find_by(name: @consumer.client_username)
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

  def recalc_cur_cons
    cur_cons = @consumer.current_en_consumption
    if cur_cons
      power = @consumer.en_bid.month_sum(Time.now.month)
      cost = (power * cur_cons.tariff).round(2)
      cost_val = (cost * 1.2).round(2)
      closing_balance = cur_cons.opening_balance - cost_val + cur_cons.money

      cur_cons.power = power
      cur_cons.cost = cost
      cur_cons.cost_val = cost_val
      cur_cons.closing_balance = closing_balance

      cur_cons.save 
    end
  end

  def detect_invalid_user
    unless current_user.admin_role?
      if current_user.manager_role?
        denied_action if @consumer.manager_en_username != current_user.name
      else
        consumers = @consumer.users.map{|n| n.name}
        consumers << @consumer.client_username
        denied_action unless consumers.include?(current_user.name)
      end
    end
  end

  def denied_action
    redirect_to :consumers, alert: "Спроба отримати доступ до споживача, що Вам не належить або не існує"
  end
end
