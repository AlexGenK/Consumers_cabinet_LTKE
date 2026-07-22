class Admin::SendMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def set_params
    @consumers = Consumer.where(energy_consumer: true).order(:name)
  end

  def start
    @sent = []
    date = params[:date].presence || Date.current

    blob = if params[:datafile].present?
      ActiveStorage::Blob.create_and_upload!(io: params[:datafile],
                                              filename: params[:datafile].original_filename,
                                              content_type: params[:datafile].content_type)
    end

    Consumer.where(id: params[:consumer_ids]).each do |consumer|
      message = consumer.messages.new(text: params[:text], created_at: date, state: 1)
      message.attach.attach(blob) if blob
      message.save
      @sent << consumer.name
    end
  end
end
