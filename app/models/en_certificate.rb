class EnCertificate < ApplicationRecord
	has_one_attached :print_form, dependent: :destroy
end
