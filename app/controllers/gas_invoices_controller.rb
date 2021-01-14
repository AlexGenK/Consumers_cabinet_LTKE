class GasInvoicesController < Invoice
	before_action :set_consumer
	
	def show
    authorize! :show, :invoice
		respond_to do |format|
      format.html { render :show }
      format.pdf do
      	data = calculate_invoice
        send_data pdf_form(data, style: 'gas').render,
                  filename: "Рахунок для #{@consumer.name} від #{DateTime.now.strftime('%Y_%m')}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
	end

	private

	def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
