class EcolCustomer < ActiveRecord::Base
  include Approval2::ModelAdditions
  include EcolCustomerValidation
  include EcolCustomerOptions

  ALLOWED_OPERATIONS = ['getStatus', 'acceptPayment', 'acceptPaymentWithCreditAcctNo', 'returnPayment']

  serialize :allowed_operations, ArrayAsCsv

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  belongs_to :credit_pass_template, :foreign_key =>'rmtr_pass_template_id', :class_name => 'NsTemplate'
  belongs_to :credit_return_template, :foreign_key =>'rmtr_return_template_id', :class_name => 'NsTemplate'

  validates_presence_of :code, :name, :is_enabled, :val_method, :token_1_type, :token_1_length, :val_token_1, :token_2_type,
  :token_2_length, :val_token_2, :token_3_type, :token_3_length, :val_token_3, :val_txn_date, :val_txn_amt, :val_ben_name, :val_rem_acct,
  :return_if_val_reject, :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :rmtr_alert_on, :credit_acct_val_pass, :should_prevalidate

  validates_uniqueness_of :code, :scope => :approval_status

  validates :token_1_length, :token_2_length, :token_3_length, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 29}
  validates :identity_user_id, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}'}, length: { maximum: 20 }, :allow_blank => true

  validates_inclusion_of :val_method, :in => %w( N W D V)
  validates_inclusion_of :token_1_type, :token_2_type, :token_3_type, :in => %w( N SC RC IN )
  validates_inclusion_of :file_upld_mthd, :in => %w( N F I ), :allow_blank => true
  validates_inclusion_of :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :in => %w( N SC RC IN RN ORN ORA TUN UDF1 UDF2 )
  validates_inclusion_of :rmtr_alert_on, :in => %w( N P R A )

  validates :code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 15, minimum: 1}
  validates :app_code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 15}, :allow_blank => true
  validates :name, format: {with: /\A[a-z|A-Z|0-9\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9\s]}' }, length: {maximum: 50, minimum: 5}
  validates :credit_acct_val_pass, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {maximum: 25, minimum: 10}
  validates :credit_acct_val_fail, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {maximum: 25, minimum: 10}, :allow_blank => true
  validates :pool_acct_no, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {maximum: 15, minimum: 15}, :allow_blank => true
  validates :rmtr_pass_txt, format: {with: /\A[a-z|A-Z|0-9|\.|\,\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\.|\,\s]}' }, length: {maximum: 500, minimum: 1}, :allow_blank => true
  validates :rmtr_return_txt, format: {with: /\A[a-z|A-Z|0-9|\.|\,\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\.|\,\s]}' }, length: {maximum: 500, minimum: 1}, :allow_blank => true
  validates :customer_id, presence: true, format: {with: /\A[1-9][0-9]+\z/, :message => 'should not start with a 0 and should contain only numbers'}, length: {maximum: 50}
  validate :presence_of_iam_cust_user
  validate :conditions_for_val_method

  validates_presence_of :allowed_operations, if: "identity_user_id.present?", message: "can't be blank when Identity User ID is present"
  validates_presence_of :identity_user_id, if: "allowed_operations.present?", message: "can't be blank when Allowed Operations is present"
  validate :code_uniqueness_for_6_4_char
  validate :validate_sub_member_bank_ifsc, if: "sub_member_bank == 'Y'"
  before_save :to_upcase
  after_create :add_ifsc, if: "sub_member_bank == 'Y'"

  def add_ifsc
    IfscDetail.create(ifsccode: self.sub_member_bank_ifsc) unless IfscDetail.find_by_ifsccode(self.sub_member_bank_ifsc).present?
  end

  def validate_sub_member_bank_ifsc
    errors.add(:sub_member_bank_ifsc, "Should be present") unless sub_member_bank_ifsc.present?
    errors.add(:sub_member_bank_ifsc, "Customer code and Sub Member Bank IFSC should be same") unless (code.upcase == sub_member_bank_ifsc.upcase)
    errors.add(:sub_member_bank_ifsc, "Customer code and Sub Member Bank IFSC should be same & maximum length for a Sub Member Bank is 8") if (sub_member_bank_ifsc.length > 8)
    errors.add(:sub_member_bank_ifsc, "Should start with YESB0") if (sub_member_bank_ifsc.first(5).upcase != "YESB0")
    errors.add(:code, "Should start with YESB0") if (code.first(5).upcase != "YESB0")
  end

  def customer_code_format
    if !code.nil? && code.start_with?("9")
      unless code =~ /\A(9[0-9]{3})\Z/i || (code =~ /\A(9[A-Z|a-z|0-9]{5})\Z/i && code !~ /\A(9[0-9]{3}[A-Z|a-z|0-9]{2})\Z/i)
        errors.add(:code, "the code can be either a 4 digit number starting with 9, or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or 6 characters alpha-numeric code starting with 9 and next 3 characters are non numbers")
      end
    else
      unless code =~ /\A[0-9A-Za-z]{4}\Z/i || code =~ /\A[0-9A-Za-z]{8}\Z/i || code =~ /\A[0-9A-Za-z]{6}\Z/i || code =~ /\A[A-Z|a-z]{4}[0][A-Za-z0-9]{6}+\Z/i
        errors.add(:code, "the code can be either a 4 character alpha-numeric code , or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or alphanumeric (with format [A-Z|a-z]{4}[0][A-Za-z0-9]{6}) with 11 characters")
      end
    end
  end

  def code_uniqueness_for_6_4_char
    if code.present? && code.length < 7
      first_four_chr_code = code.first(4).upcase

      if code.length == 4
        # the incoming value should not match the first 4 characters of an existing 6 character code
        matching_customer = EcolCustomer.unscoped.where("length(code) = 6 and  upper(code) like ? and approval_status = ? ", "#{first_four_chr_code}%", approval_status)
      else
        # the 4 first characters of the incoming value shoult not match an existing 4 character code
        matching_customer = EcolCustomer.unscoped.where("length(code) = 4 and  upper(code) = ? and approval_status = ?", first_four_chr_code, approval_status)
      end

      # other than itself
      matching_customer = matching_customer.where("id != ?", id) unless id.nil?

      if matching_customer.present?
        errors.add(:code, "starting with #{first_four_chr_code} is already taken")
      end
    end
  end

  def account_token_types
    [self.token_1_type, self.token_2_type, self.token_3_type]
  end

  def validate_account_token_length
    if ((self.token_1_type != 'N' && self.token_1_length == 0) ||
      (self.token_2_type != 'N' && self.token_2_length == 0) ||
      (self.token_3_type != 'N' && self.token_3_length == 0))
      errors[:base] << "If Account Token Type is not None then the corresponding Token Length should be greater than 0"
    end
  end

  def value_of_validation_fields
    if (self.val_token_1 == 'N' && self.val_token_2 == 'N' && self.val_token_3 == 'N' &&
       (self.val_txn_date != 'N' || self.val_txn_amt != 'N' || self.val_rem_acct != 'N'))
      errors[:base] << "Transaction Date, Transaction Amount and Remitter Account cannot be validated as no Token is validated"
    end
  end

  def to_upcase
    unless self.frozen?
      self.code = self.code.upcase unless self.code.nil?
      self.token_1_starts_with = self.token_1_starts_with.upcase unless self.token_1_starts_with.nil?
      self.token_1_contains = self.token_1_contains.upcase unless self.token_1_contains.nil?
      self.token_1_ends_with = self.token_1_ends_with.upcase unless self.token_1_ends_with.nil?
      self.token_2_starts_with = self.token_2_starts_with.upcase unless self.token_2_starts_with.nil?
      self.token_2_contains = self.token_2_contains.upcase unless self.token_2_contains.nil?
      self.token_2_ends_with = self.token_2_ends_with.upcase unless self.token_2_ends_with.nil?
      self.token_3_starts_with = self.token_3_starts_with.upcase unless self.token_3_starts_with.nil?
      self.token_3_contains = self.token_3_contains.upcase unless self.token_3_contains.nil?
      self.token_3_ends_with = self.token_3_ends_with.upcase unless self.token_3_ends_with.nil?
    end
  end

  def conditions_for_val_method
    if self.val_method == 'D' && (self.should_prevalidate != 'N')
      errors.add(:should_prevalidate, 'should be disabled when Validation Method is Database Lookup')
    end
  end

  def presence_of_iam_cust_user
    errors.add(:identity_user_id, 'IAM Customer User does not exist for this username') if identity_user_id.present? && !IamCustUser.iam_cust_user_exists?
  end

  def self.templates_for_credit_pass
    NsTemplate.joins("INNER JOIN sc_events ON sc_events.service_code = 'ECOL' AND sc_events.event_type = 'CREDIT' AND ns_templates.sc_event_id = sc_events.id")
  end

  def self.templates_for_credit_return
    NsTemplate.joins("INNER JOIN sc_events ON sc_events.service_code = 'ECOL' AND sc_events.event_type = 'RETURN' AND ns_templates.sc_event_id = sc_events.id")
  end
end
