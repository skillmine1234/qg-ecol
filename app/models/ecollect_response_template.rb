class EcollectResponseTemplate < ActiveRecord::Base
	self.table_name = "ecol_resp_templates"

	has_many :ecol_resp_parameters, class_name: 'EcolRespParameter', foreign_key: "response_template_id"
	has_many :ecol_resp_matrices, class_name: 'EcolRespMatrix', foreign_key: "response_template_id"

	accepts_nested_attributes_for :ecol_resp_parameters,reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :ecol_resp_matrices,reject_if: :all_blank, allow_destroy: true

	# validates_presence_of :client_code,:response_code

	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
end