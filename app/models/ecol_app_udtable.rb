class EcolAppUdtable < ActiveRecord::Base
  include Approval2::ModelAdditions
  
  self.table_name = "ecol_app_udtable"

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  belongs_to :ecol_app, :class_name => 'EcolApp', :primary_key => 'app_code', :foreign_key => 'app_code'
  
  validates_presence_of :app_code, :udf1

  validates_uniqueness_of :app_code, scope: [:udf1, :approval_status]
  validates_uniqueness_of :app_code, scope: [:udf1, :udf2, :approval_status], if: "ecol_app.present? && ecol_app.unique_udfs_cnt == 2"
  validates_uniqueness_of :app_code, scope: [:udf1, :udf2, :udf3, :approval_status], if: "ecol_app.present? && ecol_app.unique_udfs_cnt == 3"
  validates_uniqueness_of :app_code, scope: [:udf1, :udf2, :udf3, :udf4, :approval_status], if: "ecol_app.present? && ecol_app.unique_udfs_cnt == 4"
  validates_uniqueness_of :app_code, scope: [:udf1, :udf2, :udf3, :udf4, :udf5, :approval_status], if: "ecol_app.present? && ecol_app.unique_udfs_cnt == 5"
  
  before_validation :sanitize_udfs, unless: Proc.new { |c| c.ecol_app.nil? }
  validate :udfs_should_be_correct, unless: Proc.new { |c| c.ecol_app.nil? }
  
  def sanitize_udfs
    self.udf5 = nil if ecol_app.udfs_cnt < 5
    self.udf4 = nil if ecol_app.udfs_cnt < 4
    self.udf3 = nil if ecol_app.udfs_cnt < 3
    self.udf2 = nil if ecol_app.udfs_cnt < 2
    self.udf1 = nil if ecol_app.udfs_cnt < 1
  end
  
  def udfs_should_be_correct
    validate_udf(1, ecol_app.udf1_name, ecol_app.udf1_type, udf1)
    validate_udf(2, ecol_app.udf2_name, ecol_app.udf2_type, udf2)
    validate_udf(3, ecol_app.udf3_name, ecol_app.udf3_type, udf3)
    validate_udf(4, ecol_app.udf4_name, ecol_app.udf4_type, udf4)
    validate_udf(5, ecol_app.udf5_name, ecol_app.udf5_type, udf5)
  end

  def validate_udf(i, udf_name, udf_type, udf_value)
    errors[:base] << "#{udf_name} can't be blank" if udf_name.present? and (udf_value.nil? or udf_value.blank?)
    DateTime.parse udf_value rescue errors[:base] << "#{udf_name} is not a date" if udf_type == "date"
    errors[:base] << "#{udf_name} is too long, maximum is 50 charactres" if udf_type == "text" and udf_value.present? and udf_value.length > 50
    errors[:base] << "#{udf_name} should not include special characters" if udf_type == "text" and udf_value.present? and (udf_value =~ /[A-Za-z0-9]+$/).nil?
  end
end