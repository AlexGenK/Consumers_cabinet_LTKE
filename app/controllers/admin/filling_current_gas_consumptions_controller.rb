class Admin::FillingCurrentGasConsumptionsController < ApplicationController
	require 'csv'
  include Admin::FillingCurrentGasConsumptionsHelper
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
  end

  private

  def filling_current_gas_consumptions_params
    params.require(:filling_current_gas_consumptions).permit(:datafile)
  end
end
