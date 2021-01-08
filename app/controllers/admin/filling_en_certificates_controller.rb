class Admin::FillingEnCertificatesController < ApplicationController
	skip_before_action :verify_authenticity_token
  authorize_resource :class => false

  def start
  end
end
