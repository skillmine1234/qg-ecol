class EcolRespMatrix < ActiveRecord::Base
	belongs_to :ecollect_response_template, :foreign_key =>'response_template_id', :class_name => 'EcollectResponseTemplate'
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

	after_save :update_entry_for_approval_status

	def update_entry_for_approval_status
		attrs = ["action", "key1", "key2", "key3", "key4","key5","key6","key7","key8","key9","key10","response_template_id"]
		if (self.changed & attrs).any?
			EcolRespMatrix.where(id: self.id).update_all(approval_status: "U")
			EcolRespMatrix.where(id: self.response_template_id).update_all(approval_status: "U")
		end
  end
end