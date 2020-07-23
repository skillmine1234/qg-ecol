class EcollectResponseTemplate < ActiveRecord::Base
	self.table_name = "ecol_resp_templates"
	validates_presence_of :client_code,:response_code

	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
end