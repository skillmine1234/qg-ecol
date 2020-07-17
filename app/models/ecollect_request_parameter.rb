class EcollectRequestParameter < ActiveRecord::Base
	self.table_name = "ecol_req_parameters"
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
end
