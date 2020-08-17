class EcollectHashTemplate < ActiveRecord::Base
	belongs_to :ecollect_request_template, :foreign_key =>'request_template_id', :class_name => 'EcollectRequestTemplate'
	# has_many :ecollect_hash_parameters, class_name: 'EcollectHashParameter', foreign_key: "hash_template_id"
	# accepts_nested_attributes_for :ecollect_hash_parameters, reject_if: :all_blank, allow_destroy: true

	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
end
