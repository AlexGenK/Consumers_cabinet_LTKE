class EnInvoicesController < Invoice
  before_action :set_consumer
  load_and_authorize_resource
  
  def show
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        data = InvData.new(0, 0, 0, 0, 0)
        send_data pdf_form(data, style: 'energy').render,
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
