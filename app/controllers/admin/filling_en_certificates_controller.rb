class Admin::FillingEnCertificatesController < ApplicationController
	include Admin::FillingEnCertificatesHelper
	skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  require 'net/ftp'

  def start
  	@add_certs = []
  	@cert_list = get_newest_certs
  	@cert_list.each do |key, value|
  		consumer = Consumer.find_by(onec_id: key)
  		if consumer
  			@cert = consumer.build_en_certificate(date: value[:date])
  			@cert.save!
        Net::FTP.open(ENV['CONSUMERS_CABINET_LTKE_FTP_HOST'], 
                  ENV['CONSUMERS_CABINET_LTKE_FTP_USERNAME'],
                  ENV['CONSUMERS_CABINET_LTKE_FTP_PASSWORD'],) do |ftp| 
        	ftp.chdir('energy/')
         	ftp.getbinaryfile(value[:filename], 'public/akt.xlsx')
        end
        @cert.print_form.attach(io: File.open('public/akt.xlsx'), filename: 'akt.xlsx', content_type: 'application/vnd.ms-excel')
        @add_certs << "Потребитель #{consumer.name} (#{consumer.edrpou}) - акт от #{value[:date].strftime("%d.%m.%Y")}"
  		end
  	end
  end

  private

  def get_newest_certs
    files = {}
    Net::FTP.open(ENV['CONSUMERS_CABINET_LTKE_FTP_HOST'], 
                  ENV['CONSUMERS_CABINET_LTKE_FTP_USERNAME'],
                  ENV['CONSUMERS_CABINET_LTKE_FTP_PASSWORD'],) do |ftp|
      ftp.chdir('energy/') 
      ftp.nlst.each do |filename|
        if !files[parse_id(filename)] || files[parse_id(filename)][:date] < parse_date(filename)
          files[parse_id(filename)] = {date: parse_date(filename), filename: filename}
        end
      end
    end
    return files
  end

  def parse_date(filename)
    filename =~ /(\d\d\.\d\d\.\d\d\d\d)_.*/
    DateTime.strptime($1, '%d.%m.%Y')
  end

  def parse_id(filename)
    filename =~ /\d\d\.\d\d\.\d\d\d\d_(.+)/
    to_1cid($1)
  end
end
