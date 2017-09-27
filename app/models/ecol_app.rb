class EcolApp < ActiveRecord::Base
  include Approval2::ModelAdditions
  
  STD_APP_CODES = ['ECSTDX01','ECSTDJ01']
  SETTING_TYPES = ['text','number','date']

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  has_many :ecol_app_udtables, :class_name => 'EcolAppUdtable', :primary_key => 'app_code', :foreign_key => 'app_code'

  store :setting1, accessors: [:setting1_name, :setting1_type, :setting1_value], coder: JSON
  store :setting2, accessors: [:setting2_name, :setting2_type, :setting2_value], coder: JSON
  store :setting3, accessors: [:setting3_name, :setting3_type, :setting3_value], coder: JSON
  store :setting4, accessors: [:setting4_name, :setting4_type, :setting4_value], coder: JSON
  store :setting5, accessors: [:setting5_name, :setting5_type, :setting5_value], coder: JSON
  
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
  validates_length_of :notify_url, maximum: 100, allow_blank: true
  validates_length_of :validate_url, maximum: 100, allow_blank: true
  validates_length_of :http_username, maximum: 50, allow_blank: true
  validates_length_of :http_password, maximum: 50, allow_blank: true
  
  before_save :set_settings_cnt, :set_udfs_cnt
  validate :password_should_be_present
  validate :customer_code_be_nil, unless: "EcolApp::STD_APP_CODES.include?(app_code)"
  validate :settings_should_be_correct
  
  validates_presence_of :setting1_name, if: "setting1_name.blank? && !setting2_name.blank?", message: "can't be blank when Setting2 name is present"
  validates_presence_of :setting2_name, if: "setting2_name.blank? && !setting3_name.blank?", message: "can't be blank when Setting3 name is present"
  validates_presence_of :setting3_name, if: "setting3_name.blank? && !setting4_name.blank?", message: "can't be blank when Setting4 name is present"
  validates_presence_of :setting4_name, if: "setting4_name.blank? && !setting5_name.blank?", message: "can't be blank when Setting5 name is present"
  
  before_save :encrypt_password
  after_save :decrypt_password
  after_find :decrypt_password
  
  private

  def set_settings_cnt
    self.settings_cnt = 0
    self.settings_cnt += 1 unless setting1_name.blank?
    self.settings_cnt += 1 unless setting2_name.blank?
    self.settings_cnt += 1 unless setting3_name.blank?
    self.settings_cnt += 1 unless setting4_name.blank?
    self.settings_cnt += 1 unless setting5_name.blank?
  end
  
  def settings_should_be_correct
    validate_setting(:setting1_value, setting1_name, setting1_type, setting1_value)
    validate_setting(:setting2_value, setting2_name, setting2_type, setting2_value)
    validate_setting(:setting3_value, setting3_name, setting3_type, setting3_value)
    validate_setting(:setting4_value, setting4_name, setting4_type, setting4_value)
    validate_setting(:setting5_value, setting5_name, setting5_type, setting5_value)
  end
  
  def validate_setting(attr_name, setting_name, setting_type, setting_value)
    errors.add(attr_name, "can't be blank") if setting_name.present? && setting_value.blank?
    if setting_name.present? and setting_value.present?
      errors.add(attr_name, "invalid format, the correct format is yyyy-mm-dd") if (setting_type == "date" && setting_value =~ /\A\d{4}\-\d{2}\-\d{2}+$\z/).nil?
      Time.zone.parse setting_value rescue errors.add(attr_name, "is not a date") if setting_type == "date"
      errors.add(attr_name, "is longer than maximum (100)") if setting_type == "text" && setting_value.length > 100
      errors.add(attr_name, "should include only digits") if setting_type == "number" && (setting_value =~ /\A[0-9]+$\z/).nil?
    end
  end
  
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