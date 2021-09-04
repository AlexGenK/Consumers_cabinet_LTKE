class Admin::ReceiverController < ApplicationController
  before_action :set_receiver
  load_and_authorize_resource

  def edit
  end

  def update
    if @receiver.update(receiver_params)
      flash[:notice] = "Реквізити відредаговані" 
      redirect_to consumers_path
    else
      render :edit
    end
  end

  private

  def set_receiver
    @receiver = Receiver.first
    @receiver ||= Receiver.create(name: 'Big company')
  end

  def receiver_params
    params.require(:receiver).permit(:name, :edrpou, :account, :bank, 
                                     :account_gas, :bank_gas, :ipn, :address,
                                     :buh_name, :buh_phone, :buh_mail,
                                     :dog_name, :dog_phone, :dog_mail,
                                     :teh_name, :teh_phone, :teh_mail,
                                     :com_name, :com_phone, :com_mail,
                                     :adjustment_email, :message_email)
  end
end
