class DCompaniesController < ApplicationController
  before_action :set_d_company, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @d_companies = DCompany.order(:name)
    @d_company = DCompany.new
  end

  def create
    @d_company = DCompany.new(d_company_params)
    @d_company.save
    redirect_to d_companies_path
  end

  def destroy
    @d_company.destroy
    redirect_to d_companies_path
  end

  def edit
  end

  def update
    if @d_company.update(d_company_params)
      redirect_to d_companies_path, notice: "Компанія #{@d_company.name} успішно відредагована"
    else
      flash[:alert] = 'Неможливо відредагувати компанію'
      render :edit
    end
  end

  private

  def set_d_company
    @d_company = DCompany.find(params[:id])
  end

  def d_company_params
    params.require(:d_company).permit(:name, :operational)
  end
end
