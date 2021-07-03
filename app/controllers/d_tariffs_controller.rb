class DTariffsController < ApplicationController
  before_action :set_d_company
  load_and_authorize_resource

  def index
  end

  private

  def set_d_company
    @d_company = DCompany.find(params[:d_company_id])
  end

  def d_tariff_params
    params.require(:d_tariff).permit(:class_one, :class_two, :start_date,
                                     :decree, :decree_date)
  end
end
