class EnInvoicesController < ApplicationController
  before_action :set_consumer
  
  def show
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        send_data pdf_form.render,
                  filename: "Счет для #{@consumer.name} от #{DateTime.now.strftime('%Y_%m')}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private

  def pdf_form
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/SegoeUI.ttf")
    pdf.text "Рахунок-фактура споживача електроенергії #{@consumer.name}"
    pdf.text DateTime.now.strftime('Сгенеровано %F в %T')
    return pdf
  end

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
