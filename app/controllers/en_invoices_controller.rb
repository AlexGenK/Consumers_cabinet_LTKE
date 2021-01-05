class EnInvoicesController < Invoice
  before_action :set_consumer
  authorize_resource :class => false
  
  def show
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        data = calculate_invoice
        send_data pdf_form(data, style: 'energy').render,
                  filename: "Рахунок для #{@consumer.name} від #{DateTime.now.strftime('%Y_%m')}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private

  def calculate_invoice
    sum_vat = params[:sum].to_f.round(2)
    price = params[:tariff].to_f
    sum = (sum_vat - (sum_vat / 6)).round(2)
    vat = (sum_vat - sum).round(2)
    quantity = (sum/price).round(5)
    InvData.new(quantity, price, sum, vat, sum_vat)
  end

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
