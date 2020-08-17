class EcollectHashParameter < ActiveRecord::Base
	belongs_to :ecollect_request_template, :foreign_key =>'request_template_id', :class_name => 'EcollectRequestTemplate'
end