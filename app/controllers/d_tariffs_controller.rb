class DTariffsController < ApplicationController
  before_action :set_d_company
  before_action :set_d_tariff, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @d_tariffs = @d_company.d_tariffs.all.order(:start_date)
  end

  def new
    @d_tariff = @d_company.d_tariffs.new
  end

  def create
    @d_tariff = @d_company.d_tariffs.new(d_tariff_params)
    if @d_tariff.save
      redirect_to d_company_d_tariffs_path(@d_company)
    else
      flash[:alert] = 'Неможливо додати нові тарифи'
      render :edit
    end
  end

  def edit
  end

  def update
    if @d_tariff.update(d_tariff_params)
       redirect_to d_company_d_tariffs_path(@d_company), notice: "Тврифи успішно відредаговані"
    else
      flash[:alert] = 'Неможливо відредагувати тарифи'
      render :edit
    end
  end

  def destroy
    @d_tariff.destroy
    redirect_to d_company_d_tariffs_path(@d_company)
  end

  private

  def set_d_company
    @d_company = DCompany.find(params[:d_company_id])
  end

  def set_d_tariff
    @d_tariff = @d_company.d_tariffs.find(params[:id])
  end

  def d_tariff_params
    params.require(:d_tariff).permit(:class_one, :class_two, :start_date,
                                     :decree, :decree_date)
  end
end
