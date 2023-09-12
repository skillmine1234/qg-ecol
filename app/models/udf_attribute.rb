class UdfAttribute < ActiveRecord::Base
  include Approval2::ModelAdditions
  include UdfAttributeValidation
  attr_writer :length, :max_length, :min_length, :min_value, :max_value
  attr_reader :length, :max_length, :min_length, :min_value, :max_value

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

  CONTROL_TYPES = %w(TextBox DropDown CheckBox)
  DATA_TYPES = %w(String Numeric Date)
  TextValidators = {:length => ['number', 'is'], :min_length => ['number', 'minimum'], :max_length => ['number', 'maximum']}.freeze
  NumericValidators = {:min_value => ['number', 'minimum'], :max_value => ['number', 'maximum']}.freeze
    
  serialize :constraints
  serialize :select_options
  
  before_save :construct_validate_hash
  after_initialize :regenerate_accessor_fields, if: Proc.new { |tf| tf.constraints.present? }
  
  def select_options_list
    if select_options.to_s.empty? 
      nil
    else
      YAML.load(select_options) rescue nil 
    end
  end

  def check_syntax_for_select_options
    values = select_options.to_s.split("\n")
    values.each do |v|
      key_value = v.split(":")
      unless key_value.empty?
      key_value.each do |kv|
          return false if (/\A"/).match(kv.strip).nil? or (/"\Z/).match(kv.strip).nil?
        end
      end
    end
  end

  def type
    if control_type == "CheckBox"
      "boolean"
    elsif control_type == "DropDown"
      "select"
    elsif control_type == "TextBox"
      data_type == "Date" ? "date" : "string"
    end
  end
    
  def regenerate_accessor_fields
    constraints.each do |k,v|
      v.is_a?(Hash) ? self.send("#{k.to_s}=",v[v.keys.first]) : self.send("#{k.to_s}=", v)
    end
    self.format = "/"+self.format.source+"/" if self.format rescue ""
  end

  def construct_validate_hash
    hash = {}
    validators = TextValidators.merge(NumericValidators)
    validators.each do |k,v|
      value = self.send(k)
      if value.present?
        value = value.is_a?(String) ? eval(value) : value
        if v.length > 1
          hash[k] = {v.last.to_sym => value}
          hash[k].merge!(:message => "should be of #{value} characters") if k == :length
        elsif !value.zero?
          hash[k] = value
        end
      end
    end
    self.constraints = hash
  end
    
  def self.options_for_attribute_name(name)
    existing_values = self.unscoped.all.map {|u| u.attribute_name}
    values = existing_values.delete(name)
    %w(udf1 udf2 udf3 udf4 udf5 udf6 udf7 udf8 udf9 udf10 udf11 udf12 udf13 udf14 udf15 udf16 udf17 udf18 udf19 udf20) - existing_values
  end  

  def self.check
    return true if !(1==1) 
  end
end
