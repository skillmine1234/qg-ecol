module UdfValidation

  def value_types
    udfs.each do |field|
      udf_value = send(field.attribute_name)
      if !udf_value.to_s.strip.empty?
        field_type = field.data_type
        if field_type == 'Numeric' && !is_a_number?(udf_value)
          test_numeric_value(field)
        elsif field_type == 'Date'
          test_date_value(field,udf_value)
        end
      end
    end
    return true
  end

  def test_numeric_value(field)
    errors.add(field.attribute_name,"Should be Numeric Value")
    return false
  end

  def test_date_value(field,udf_value)
    if !is_a_date?(udf_value)
      errors.add(field.attribute_name,"Should be Date")
      return false
    end
  end

  def mandatory_value
    udfs.each do |field|
      udf_value = send(field.attribute_name)
      if field.is_mandatory =='Y' && udf_value.blank?
        errors.add(field.attribute_name,"is required")
        return false
      end
    end
    return true
  end

  def constraints
    udfs.each do |field|
      udf_value = send(field.attribute_name)
      if field.data_type == "String" and !udf_value.nil?
        test_string_value(field,udf_value)
      elsif field.data_type == "Numeric" and !udf_value.nil?
        test_numeric_value_range(field,udf_value)
      end
    end
    return true
  end

  def test_string_value(field,udf_value)
    field.constraints.each do |k,v|
      if k == :length and !v[:is].blank?
        test_length_value(field,v,udf_value)       
      elsif k == :min_length and !v[:minimum].blank?
        test_min_length_value(field,v,udf_value)
      elsif k == :max_length and !v[:maximum].blank?
        test_max_length_value(field,v,udf_value)
      end
    end
  end

  def test_length_value(field,v,udf_value)
    errors.add(field.attribute_name,v[:message]) if !udf_value.to_s.strip.empty? and udf_value.length != v[:is] 
    return false  
  end

  def test_min_length_value(field,v,udf_value)
    errors.add(field.attribute_name,"is too short (minimum is #{v[:minimum]} characters)") if !udf_value.to_s.strip.empty? and udf_value.length < v[:minimum]
    return false
  end

  def test_max_length_value(field,v,udf_value)
    errors.add(field.attribute_name,"is too long (maximum is #{v[:maximum]} characters)") if !udf_value.to_s.strip.empty? and udf_value.length > v[:maximum]
    return false
  end

  def test_numeric_value_range(field,udf_value)
    field.constraints.each do |k,v|           
      if k == :min_value and !v[:minimum].blank?
        test_min_value(field,v,udf_value)
      elsif k == :max_value and !v[:maximum].blank?
        test_max_value(field,v,udf_value)
      end
    end
  end

  def test_min_value(field,v,udf_value)
    errors.add(field.attribute_name,"is less than #{v[:minimum]}") if !udf_value.to_s.strip.empty? and udf_value.to_f < v[:minimum].to_f
    return false
  end

  def test_max_value(field,v,udf_value)
    errors.add(field.attribute_name,"is more than #{v[:maximum]}") if !udf_value.to_s.strip.empty? and udf_value.to_f > v[:maximum].to_f
    return false
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def is_a_date?(s)
    date = (s =~ /^\d{4}\-\d{2}\-\d{2}$/) rescue nil
    date = Date.parse(s) rescue nil unless date.nil?
    date == nil ? false : true
  end
end