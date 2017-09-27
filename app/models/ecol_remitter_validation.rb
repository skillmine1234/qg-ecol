module EcolRemitterValidation
  extend ActiveSupport::Concern
  included do
    validates :customer_code, presence: true, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}'}, length: {maximum: 15, minimum: 1}
    validates :customer_subcode, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}'}, length: {maximum: 28, minimum: 1}, :allow_blank =>true
    validates :remitter_code, presence: true, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 28, minimum: 1}
    validates :credit_acct_no, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {maximum: 25, minimum: 10}, :allow_blank =>true
    validates :customer_subcode_mobile, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {maximum: 10, minimum: 10}, :allow_blank =>true 
    validates :rmtr_name, presence: true, format: {with: /\A[a-z|A-Z|0-9|\:|\/|\-|\?|\+|\(|\)|\.|\,\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\:|\/|\-|\?|\+|\(|\)|\.|\,\s]}'}, length: {maximum: 100, minimum: 2}
    validates :rmtr_address, format: {with: /\A[a-z|A-Z|0-9|\:|\/|\-|\?|\+|\(|\)|\.|\,\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\:|\/|\-|\?|\+|\(|\)|\.|\,\s]}'}, length: {maximum: 100, minimum: 2}, :allow_blank =>true
    validates :rmtr_acct_no, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 25, minimum: 1}, :allow_blank =>true
    validates :rmtr_mobile, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}'}, length: {maximum: 10, minimum: 10}, :allow_blank =>true
    validates :invoice_no, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 28, minimum: 1}, :allow_blank =>true
  
    validates :invoice_amt, presence: true, :format => { :with => /\A\d+(?:\.\d{1,2})?\z/ , :message => "only 2 decimal places are allowed"}, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => '9e15'.to_f, :allow_nil => true }
    validates :invoice_amt_tol_pct, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :allow_nil => true }
    validates :min_credit_amt, :format => { :with => /\A\d+(?:\.\d{1,2})?\z/ , :message => "only 2 decimal places are allowed" }, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => '9e15'.to_f, :allow_nil => true }
    validates :max_credit_amt, :format => { :with => /\A\d+(?:\.\d{1,2})?\z/ , :message => "only 2 decimal places are allowed" }, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => '9e15'.to_f, :allow_nil => true }
    validates :due_date_tol_days, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 28, :allow_nil => true }
    validates :due_date, presence: true
  
    validates_uniqueness_of :customer_code, :scope => [:remitter_code, :invoice_no,:approval_status], if: Proc.new { |c| c.customer_subcode.to_s.empty? and !c.invoice_no.to_s.empty?}
    validates_uniqueness_of :customer_code, :scope => [:remitter_code, :customer_subcode,:approval_status], if: Proc.new { |c| !c.customer_subcode.to_s.empty? and c.invoice_no.to_s.empty?}
    validates_uniqueness_of :customer_code, :scope => [:remitter_code,:approval_status], if: Proc.new { |c| c.customer_subcode.to_s.empty? and c.invoice_no.to_s.empty?}
    validates_uniqueness_of :customer_code, :scope => [:remitter_code, :customer_subcode, :invoice_no,:approval_status], if: Proc.new { |c| !c.customer_subcode.to_s.empty? and !c.invoice_no.to_s.empty?}

    validate :value_types
    validate :mandatory_value
    validate :constraints
    validate :validate_customer_subcode_details, :customer_code_should_exist, :check_email_address  
  end

  def validate_customer_subcode_details
    if self.customer_subcode.blank? 
      errors.add(:customer_subcode_email,"should be empty when customer_subcode is empty") if !self.customer_subcode_email.blank?
      errors.add(:customer_subcode_mobile,"should be empty when customer_subcode is empty") if !self.customer_subcode_mobile.blank?
    end
  end 

  def check_email_address
    ["customer_subcode_email","rmtr_email"].each do |email_id|
      invalid_ids = []
      value = self.send(email_id)
      unless value.nil?
        value.split(/;\s*/).each do |email| 
          unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
            invalid_ids << email
          end
        end
      end
      errors.add(email_id.to_sym, "is invalid") unless invalid_ids.empty?
    end
  end

  def customer_code_should_exist
    unless self.customer_code.nil?
      ecol_customer = EcolCustomer.where("upper(code)=?", self.customer_code.upcase)
      if ecol_customer.empty? 
        errors.add(:customer_code, "Invalid Customer")
      end
    end
  end
end