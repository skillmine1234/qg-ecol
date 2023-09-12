module UdfAttributeHelper
  
  def label_value(value)
    if value == :min_length
      'Min Length'
    elsif value == :max_length
      'Max Length'
    elsif value == :min_value
      'Min Value'
    elsif value == :max_value
      'Max Value'
    end
  end
  
end