module UdfAttributeValidation
  extend ActiveSupport::Concern
  included do
    validate :validate_options
    validates_presence_of :class_name, :attribute_name, :is_enabled
    validate :validate_data_type
    validate :validate_constraint_input
    validate :cross_field_validations
    validate :validate_length
    validate :validate_value
    validates_uniqueness_of :attribute_name, :scope => [:class_name,:approval_status]
    validates :max_value, :min_value, :length, :max_length, :min_length, :numericality => { :greater_than => 0}, :allow_blank => true
  end

  def validate_constraint_input
    if self.data_type == "String" and !self.length.to_s.empty? and (!self.min_length.to_s.empty? or !self.max_length.to_s.empty?)
      errors.add(:data_type, "Please specify Either Length or (min Length and max Length) for this data type")
    end
  end

  def validate_data_type
    if control_type == "TextBox" and data_type.to_s.empty?
      errors.add(:data_type, "should be present for TextBox control") 
    end
  end

  def validate_length
    if self.data_type == "String" and !self.min_length.to_s.empty? and !self.max_length.to_s.empty?
      errors.add(:data_type, "Min length should be less than max length") if min_length.to_i > max_length.to_i
    end
  end

  def validate_value
    if self.data_type == "Numeric" and !self.min_value.to_s.empty? and !self.max_value.to_s.empty?
      errors.add(:data_type, "Min value should be less than max value") if min_value.to_i > max_value.to_i
    end
  end

  def validate_options
    if !select_options.to_s.empty? and control_type == "DropDown"
      valid_flag = YAML.load(select_options).to_a rescue false
      errors.add(:select_options,"not in the following format <br> \"name1\": \"value1\" <br> \"name2\": \"value2\" <br>") if valid_flag == false or check_syntax_for_select_options == false
    elsif select_options.to_s.empty? and control_type == "DropDown"
      errors.add(:select_options,"can't be empty when control type is DropDown")
    end
  end

  def cross_field_validations
    errors.add(:label_text, "Label_text is mandatory if is_enabled is Y") if (self.is_enabled == 'Y' && self.label_text.blank?)       
    errors.add(:control_type, "Control_type is mandatory if is_enabled is Y") if (self.is_enabled == 'Y' && self.control_type.blank?)      
    errors.add(:control_type, "Constraints cannot be entered if control_type is Dropdown") if (self.control_type ==  "DropDown" && (!self.max_length.blank? || !self.min_length.blank?))
  end
end