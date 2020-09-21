class EcollectEncryptDecrypt < ActiveRecord::Base
	belongs_to :ecollect_request_template, :foreign_key =>'request_template_id', :class_name => 'EcollectRequestTemplate'
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
	after_save :update_entry_for_approval_status

	def update_entry_for_approval_status
		attrs = ["algorithm", "key", "parameter_type", "request_template_id", "secret_key","decrypt_response"]
		if (self.changed & attrs).any?
			EcollectEncryptDecrypt.where(id: self.id).update_all(approval_status: "U")
			EcollectRequestTemplate.where(id: self.request_template_id).update_all(approval_status: "U")
		end
  end
end