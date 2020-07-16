class EcollectHashParameter < ActiveRecord::Base
	belongs_to :ecollect_hash_template, :foreign_key =>'hash_template_id', :class_name => 'EcollectHashTemplate'
end
