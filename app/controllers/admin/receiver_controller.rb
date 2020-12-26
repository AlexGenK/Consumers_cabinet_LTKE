class Admin::ReceiverController < ApplicationController
  before_action :set_receiver
  load_and_authorize_resource

  def edit
  end

  def update
    if @receiver.update(receiver_params)
      flash[:notice] = "Платіжні реквізити відредаговані" 
      redirect_to consumers_path
    else
      render :edit
    end
  end

  private

  def set_receiver
    @receiver = Receiver.first
  end

  def receiver_params
    params.require(:receiver).permit(:name, :edrpou, :account, :bank, :ipn, :address)
  end
end
