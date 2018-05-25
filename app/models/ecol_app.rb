class EcolApp < ActiveRecord::Base
  include Approval2::ModelAdditions

  TOTAL_SETTINGS_COUNT = 5
  include Setting

  STD_APP_CODES = ['ECSTDX01','ECSTDJ01']

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  has_many :ecol_app_udtables, :class_name => 'EcolAppUdtable', :primary_key => 'app_code', :foreign_key => 'app_code'

  store :udf1, accessors: [:udf1_name, :udf1_type], coder: JSON
  store :udf2, accessors: [:udf2_name, :udf2_type], coder: JSON
  store :udf3, accessors: [:udf3_name, :udf3_type], coder: JSON
  store :udf4, accessors: [:udf4_name, :udf4_type], coder: JSON
  store :udf5, accessors: [:udf5_name, :udf5_type], coder: JSON

  validates_presence_of :app_code
  validates_presence_of :customer_code, if: "EcolApp::STD_APP_CODES.include?(app_code)"
  validate :match_customer, if: "customer_code.present?"
  
  validates_uniqueness_of :app_code, :scope => [:customer_code, :approval_status]
  validates_uniqueness_of :customer_code, :scope => :approval_status, if: "customer_code.present?"
  
  validates_length_of :app_code, maximum: 50
  validates_length_of :customer_code, maximum: 20, allow_blank: true
  validates_length_of :notify_url, maximum: 500, allow_blank: true
  validates_length_of :validate_url, maximum: 500, allow_blank: true
  validates_length_of :http_username, maximum: 50, allow_blank: true
  validates_length_of :http_password, maximum: 50, allow_blank: true
  
  before_save :set_udfs_cnt
  validate :password_should_be_present
  validate :customer_code_be_nil, unless: "EcolApp::STD_APP_CODES.include?(app_code)"

  before_save :encrypt_password
  after_save :decrypt_password
  after_find :decrypt_password
  
  private

  def set_udfs_cnt
    self.udfs_cnt = 0
    self.udfs_cnt += 1 unless udf1_name.blank?
    self.udfs_cnt += 1 unless udf2_name.blank?
    self.udfs_cnt += 1 unless udf3_name.blank?
    self.udfs_cnt += 1 unless udf4_name.blank?
    self.udfs_cnt += 1 unless udf5_name.blank?
  end
  
  def decrypt_password
    self.http_password = DecPassGenerator.new(http_password,ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']).generate_decrypted_data if http_password.present?
  end
  
  def encrypt_password
    self.http_password = EncPassGenerator.new(self.http_password, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']).generate_encrypted_password unless http_password.to_s.empty?
  end

  def password_should_be_present
    errors[:base] << "HTTP Password can't be blank if HTTP Username is present" if self.http_username.present? and (self.http_password.blank? or self.http_password.nil?)
  end
  
  def customer_code_be_nil
    errors[:base] << "Customer Code is not allowed if the App Code is not Standard" if customer_code.present?
  end

  def match_customer
    customer = EcolCustomer.find_by(code: customer_code, approval_status: 'A')
    if customer.present?
      errors[:base] << "This customer neither supports validation nor notification" if customer.val_method == 'N' && customer.cust_alert_on == 'N'
      errors[:base] << "Validate URL can't be blank since the customer setup requires validation" if customer.val_method == 'W' && validate_url.blank?
      errors[:base] << "Notify URL can't be blank since the customer setup requires notification" if customer.cust_alert_on != 'N' && notify_url.blank?
    else
      errors[:base] << "Customer setup should be present in EcolCustomer for this code"
    end
  end
end