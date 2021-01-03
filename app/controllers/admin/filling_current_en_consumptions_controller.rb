class Admin::FillingCurrentEnConsumptionsController < ApplicationController
  require 'csv'
  include Admin::FillingCurrentEnConsumptionsHelper
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
  end

  def start
  end

  private

  def filling_current_en_consumptions_params
    params.require(:filling_current_en_consumptions).permit(:datafile)
  end
end
