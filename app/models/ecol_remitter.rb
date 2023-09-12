class EcolRemitter < ActiveRecord::Base
  include UdfValidation
  include EcolCustomersHelper
  include Approval2::ModelAdditions
  include EcolRemitterValidation
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  belongs_to :ecol_customer

  validates_presence_of :is_enabled
  validates_absence_of :additional_email_ids, unless: "rmtr_email.present?", message: "must be blank when Remitter Email is not set"
  validates_absence_of :additional_mobile_nos, unless: "rmtr_mobile.present?", message: "must be blank when Remitter Mobile is not set"
  validate :check_email_ids, :check_mobile_nos
  validates_length_of :additional_email_ids, maximum: 2000, allow_blank: true
  validates_length_of :additional_mobile_nos, maximum: 500, allow_blank: true
  
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
  
  def check_email_ids
    invalid_ids = []
    value = self.additional_email_ids
    unless value.nil?
      value.split(/,\s*/).each do |email| 
        unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
          invalid_ids << email
        end
      end
    end
    errors.add(:additional_email_ids, "is invalid") unless invalid_ids.empty?
  end
  
  def check_mobile_nos
    invalid_nos = []
    value = self.additional_mobile_nos
    unless value.nil?
      value.split(/,\s*/).each do |mobile_no| 
        unless mobile_no =~ /\A[0-9]{10}+\z/i
          invalid_nos << mobile_no
        end
      end
    end
    errors.add(:additional_mobile_nos, "is invalid") unless invalid_nos.empty?
  end
end
