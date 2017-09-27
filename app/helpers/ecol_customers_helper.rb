module EcolCustomersHelper
  
  def show_page_value_for_account_tokens(value)
    if (value == "N")
      "None"
    elsif (value == "SC")
      "Sub Code"
    elsif (value == "RC")
      "Remitter Code"
    elsif (value == "IN")
      "Invoice Number"
    end
  end
  
  def show_page_value_for_val_method(value)
    if (value == "N")
      "None"
    elsif (value == "W")
      "Web Service"
    elsif (value == "D")
      "Database Lookup"
    end
  end
  
  def find_ecol_customers(params)
    ecol_customers = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcolCustomer.unscoped : EcolCustomer
    ecol_customers = ecol_customers.where("approval_status=?",params[:approval_status]) if params[:approval_status].present?
    ecol_customers = ecol_customers.where("code=?",params[:code]) if params[:code].present?
    ecol_customers = ecol_customers.where("is_enabled=?",params[:is_enabled]) if params[:is_enabled].present?
    ecol_customers = ecol_customers.where("credit_acct_val_pass=?",params[:credit_acct_val_pass]) if params[:credit_acct_val_pass].present?
    ecol_customers = ecol_customers.where("credit_acct_val_fail=?",params[:credit_acct_val_fail]) if params[:credit_acct_val_fail].present?
    ecol_customers
  end

  def show_page_value_for_nrtv_sufx(value)
    case value
    when "N"
      "None"
    when "SC"
      "Sub Code"
    when "RC"
      "Remitter Code"
    when "IN"
      "Invoice Number"
    when "RN"
      "Remitter Name"
    when "ORN"
      "Original Remitter Name"
    when "ORA"
      "Original Remitter Account"
    when "TUN"
      "Transfer Unique No"
    when "UDF1"
      "User Defined Field 1"
    when "UDF2"
      "User Defined Field 2"  
    end
  end
  
  def get_allowed_operations(value)
    value.join(', ') unless value.nil?
  end
end
