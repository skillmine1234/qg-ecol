module EcolTransactionsHelper
  
  def find_ecol_transactions(transactions,params)
    ecol_transactions = transactions
    ecol_transactions = ecol_transactions.where("LOWER(transfer_unique_no) LIKE ?", "%#{params[:transfer_unique_no].downcase}%") if params[:transfer_unique_no].present?
    ecol_transactions = ecol_transactions.where("LOWER(customer_code) LIKE ?", "%#{params[:customer_code].downcase}%").split(",").collect(&:strip)) if params[:customer_code].present?
    ecol_transactions = ecol_transactions.where("LOWER(status) LIKE ?", "%#{params[:status ].downcase}%").split(",").collect(&:strip)) if params[:status].present?
    ecol_transactions = ecol_transactions.where("LOWER(pending_approval) LIKE ?", "%#{params[:pending_approval ].downcase}%") if params[:pending_approval].present?
    ecol_transactions = ecol_transactions.where("LOWER(decision_by) LIKE ?", "%#{params[:decision_by].downcase}%") if params[:decision_by].present?
    ecol_transactions = ecol_transactions.where("LOWER(notify_status) LIKE ?", "%#{params[:notification_status].downcase}%") if params[:notification_status].present?
    ecol_transactions = ecol_transactions.where("LOWER(validation_status) LIKE ?", "%#{params[:validation_status].downcase}%") if params[:validation_status].present?
    ecol_transactions = ecol_transactions.where("LOWER(settle_status) LIKE ?", "%#{params[:settle_status].downcase}%") if params[:settle_status].present?
    ecol_transactions = ecol_transactions.where("LOWER(transfer_type) LIKE ?", "%#{params[:transfer_type].downcase}%") if params[:transfer_type].present?
    ecol_transactions = ecol_transactions.where("LOWER(return_transfer_type) LIKE ?", "%#{params[:return_transfer_type].downcase}%") if params[:return_transfer_type].present?
    ecol_transactions = ecol_transactions.where("LOWER(bene_account_no) LIKE ?", "%#{params[:bene_account_no].downcase}%") if params[:bene_account_no].present?
    ecol_transactions = ecol_transactions.where("LOWER(rmtr_account_ifsc) LIKE ?", "%#{params[:rmtr_account_ifsc ].downcase}%") if params[:rmtr_account_ifsc].present?
    ecol_transactions = ecol_transactions.where("LOWER(customer_code) LIKE ?", "%#{params[:customer_code ].downcase}%") if params[:customer_code ].present?
    ecol_transactions = ecol_transactions.where("LOWER(customer_code) LIKE ?", "%#{params[:customer_code ].downcase}%") if params[:customer_code ].present?
    ecol_transactions = ecol_transactions.where("LOWER(customer_code) LIKE ?", "%#{params[:customer_code ].downcase}%") if params[:customer_code ].present?
    ecol_transactions
  end
  
  def ecol_transaction_token_show(ecol_transaction, indx)
    unless ecol_transaction.ecol_customer.nil?
      token_types = ecol_transaction.ecol_customer.account_token_types
      case token_types[indx]
      when 'SC'
        token_value = ecol_transaction.customer_subcode
      when 'RC'
        token_value = ecol_transaction.remitter_code
        unless ecol_transaction.ecol_remitter.nil?
          link_to token_value, ecol_transaction.ecol_remitter
        else
          token_value
        end
      when 'IN'
        token_value = ecol_transaction.invoice_no
      end
    else
      "-"
    end
  end
  
  def txn_summary_count(status_hash,key) 
    count = status_hash[key] rescue 0 
    count.nil? ? 0 : count
  end
  
  def show_page_value_for_validation_status(ecol_transaction,value)
    value == "0" ? "SUCCESS" : ecol_transaction.validation_status
  end

  def pending_status(state)
    (state == 'CREDIT FAILED' or state == 'RETURN FAILED' or state == 'VALIDATION FAILED')
  end

  def find_pending_status(state)
    state.split(' ').first if (state == 'CREDIT FAILED' or state == 'RETURN FAILED' or state == 'VALIDATION FAILED')
  end

  def approval_status(state)
    (state == 'PENDING CREDIT' or state == 'PENDING RETURN' or state == 'CREDIT FAILED' or state == 'RETURN FAILED')
  end

  def find_approval_status(state)
    (state == 'PENDING CREDIT' or state == 'PENDING RETURN') ? state.split(' ').last : state.split(' ').first
  end

  def find_logs(params,transaction)
    if params[:step_name] != 'ALL'
      transaction.ecol_audit_logs.where('step_name=?',params[:step_name]).order("attempt_no desc") rescue []
    else
      transaction.ecol_audit_logs.order("id desc") rescue []
    end      
  end

  def check_transactions(transactions,params)
    if !params[:status].to_s.empty?
      {:records => transactions.select{|transaction| transaction.status != params[:status]}, :status => params[:status]}
    elsif !params[:settle_status].to_s.empty?
      {:records => transactions.select{|transaction| transaction.settle_status != params[:settle_status]}, :status => params[:settle_status]}
    elsif !params[:notify_status].to_s.empty?
      {:records => transactions.select{|transaction| transaction.notify_status != params[:notify_status]}, :status => params[:notify_status]}
    end
  end

  def update_transactions(transactions,params)
    transactions.each do |ecol_transaction|
      if params[:approval] == 'Y'
        ecol_transaction.update_attributes(:pending_approval => "N")
      elsif params[:status].present?
        if params[:status].split(' ')[0] == 'VALIDATION'
          ecol_transaction.update_attributes(:pending_approval => "N", :status => 'PENDING ' + params[:status].split(' ')[0], :validation_status => 'PENDING ' + params[:status].split(' ')[0]) 
        else
          ecol_transaction.update_attributes(:pending_approval => "N", :status => 'PENDING ' + params[:status].split(' ')[0]) 
        end 
      elsif params[:settle_status].present?
        ecol_transaction.update_attributes(:pending_approval => "N", :settle_status => 'PENDING ' + params[:settle_status].split(' ')[0])  
      elsif params[:notify_status].present?
        ecol_transaction.update_attributes(:pending_approval => "N", :notify_status => 'PENDING ' + params[:notify_status].split(' ')[0])  
      end
    end
  end
  
  def desc_for_decision_by(value)
    case value
    when 'A'
      'Automatic'
    when 'H'
      'Human'
    when 'W'
      'WebService'
    end
  end

  def check_pending_validation(ecol_transaction)
    unapproved = UnapprovedRecord.where(approvable_id: ecol_transaction.id)
    if (unapproved == [])
      true
    else
      false
    end
  end

end
