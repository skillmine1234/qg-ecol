class EcollectRequestTemplate < ActiveRecord::Base
	has_many :ecollect_hash_templates, class_name: 'EcollectHashTemplate', foreign_key: "request_template_id"
	has_many :ecollect_request_parameters, class_name: 'EcollectRequestParameter', foreign_key: "request_template_id"
	has_one :ecollect_encrypt_decrypt, class_name: 'EcollectEncryptDecrypt', foreign_key: "request_template_id"
	has_many :ecollect_hash_parameters, class_name: 'EcollectHashParameter', foreign_key: "request_template_id"

	accepts_nested_attributes_for :ecollect_hash_templates
	accepts_nested_attributes_for :ecollect_hash_parameters
	accepts_nested_attributes_for :ecollect_request_parameters

	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

	validates_inclusion_of :step_name, :in => %w( VAL NOT )

	def self.customer_code_exist(customer_code)
    ecol_customer_code = EcolCustomer.where(code: customer_code)
    return ecol_customer_code.present? ? true : false
  end
  
end