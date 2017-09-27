class EcolRemitter < ActiveRecord::Base
  include UdfValidation
  include EcolCustomersHelper
  include Approval2::ModelAdditions
  include EcolRemitterValidation
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  belongs_to :ecol_customer
  
  before_save :to_upcase
  
  def udfs
    UdfAttribute.where("is_enabled=?",'Y').order("id asc")
  end
  
  def to_upcase
    unless self.frozen? 
      self.customer_code = self.customer_code.upcase unless self.customer_code.nil?
      self.remitter_code = self.remitter_code.upcase unless self.remitter_code.nil?
      self.invoice_no = self.invoice_no.upcase unless self.invoice_no.nil?
    end
  end
end
