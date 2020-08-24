class EcolRespParameter < ActiveRecord::Base
	belongs_to :ecollect_response_template, :foreign_key =>'response_template_id', :class_name => 'EcollectResponseTemplate'
end
