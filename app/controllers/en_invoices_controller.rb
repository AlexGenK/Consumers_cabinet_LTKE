class EnInvoicesController < Invoice
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

  def set_consumer
    @consumer = Consumer.find(params[:consumer_id])
  end
end
