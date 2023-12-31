class EcollectResponseTemplate < ActiveRecord::Base
	self.table_name = "ecol_resp_templates"
	audited

	has_many :ecol_resp_parameters, class_name: 'EcolRespParameter', foreign_key: "response_template_id"
	has_many :ecol_resp_matrices, class_name: 'EcolRespMatrix', foreign_key: "response_template_id"

	accepts_nested_attributes_for :ecol_resp_parameters,reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :ecol_resp_matrices,reject_if: proc { |attributes|  attributes['action'].blank? && attributes['key1'].blank? && attributes['key2'].blank? && attributes['key3'].blank? && attributes['key4'].blank? && attributes['key5'].blank? && attributes['key6'].blank? && attributes['key7'].blank? && attributes['key8'].blank? && attributes['key9'].blank? && attributes['key10'].blank?}, allow_destroy: true

	validates_uniqueness_of :client_code,:scope => [:api_type,:response_code]

	# validates_presence_of :client_code,:response_code

	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

	validates_inclusion_of :step_name, :in => %w( VAL NOT )

	after_create :create_entry_in_unapproved_record

	def create_entry_in_unapproved_record
  	UnapprovedRecord.create(approvable_id: self.id, approvable_type: "EcollectResponseTemplate")
  end
end