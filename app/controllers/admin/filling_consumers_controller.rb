class Admin::FillingConsumersController < ApplicationController
	require 'csv'

	skip_before_action :verify_authenticity_token

  def set_params
  end

  def start
  end

  private

  def filling_consumptions_params
    params.require(:filling_consumers).permit(:datafile)
  end
end