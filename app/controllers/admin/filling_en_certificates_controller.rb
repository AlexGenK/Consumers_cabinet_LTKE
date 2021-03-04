class Admin::FillingEnCertificatesController < ApplicationController
	include Admin::FillingEnCertificatesHelper
	skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  require 'net/ftp'

  def start
    @add_certs = []
    Net::FTP.open(ENV['CONSUMERS_CABINET_LTKE_FTP_HOST'], 
                  port: ENV['CONSUMERS_CABINET_LTKE_FTP_PORT'],
                  username: ENV['CONSUMERS_CABINET_LTKE_FTP_USERNAME'],
                  password: ENV['CONSUMERS_CABINET_LTKE_FTP_PASSWORD'],) do |ftp|
      ftp.chdir('certificates/en') 
      ftp.nlst.each do |filename|
        consumer_id = parse_id(filename)
        consumer_dog = parse_dog(filename)
        p "#{consumer_id} - #{consumer_dog}"
        @consumer = Consumer.find_by(onec_id: consumer_id, dog_num: consumer_dog, energy_consumer: true)
        if @consumer
          @consumer.en_certificate&.destroy
          @cert = @consumer.build_en_certificate
          @cert.save!
          ftp.getbinaryfile(filename, 'public/akt.pdf')
          @cert.print_form.attach(io: File.open('public/akt.pdf'), filename: 'akt.pdf', content_type: 'application/pdf')
          @add_certs << "Споживач #{@consumer.name} (#{@consumer.edrpou}) - договір №#{@consumer.dog_num}"
        end
      end
    end
  end

  private

  def parse_dog(filename)
    filename =~ /.+_(.+)\..*/
    $1.gsub(/\$/, '/')
  end

  def parse_id(filename)
    filename =~ /._(.+)_.+/
    to_1cid($1)
  end
end
