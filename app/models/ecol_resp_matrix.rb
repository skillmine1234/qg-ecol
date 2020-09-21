class EcolRespMatrix < ActiveRecord::Base
	belongs_to :ecollect_response_template, :foreign_key =>'response_template_id', :class_name => 'EcollectResponseTemplate'
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
end