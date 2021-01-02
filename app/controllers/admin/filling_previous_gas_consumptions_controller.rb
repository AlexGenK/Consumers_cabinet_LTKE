class Admin::FillingPreviousGasConsumptionsController < ApplicationController
  require 'csv'
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
  end

  private

  def filling_previous_gas_consumptions_params
    params.require(:filling_previous_gas_consumptions).permit(:datafile)
  end
end
