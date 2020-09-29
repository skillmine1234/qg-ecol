class EcolRespParameter < ActiveRecord::Base
	belongs_to :ecollect_response_template, :foreign_key =>'response_template_id', :class_name => 'EcollectResponseTemplate'
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

	after_save :update_entry_for_approval_status

	def update_entry_for_approval_status
		attrs = ["expression_to_evaluate", "response_template_id", "parameter_type", "key", "ecollect_response_key","response_matrix_key"]
		if (self.changed & attrs).any?
			EcolRespParameter.where(id: self.id).update_all(approval_status: "U")
			EcolRespParameter.where(id: self.response_template_id).update_all(approval_status: "U")
		end
  end
end
