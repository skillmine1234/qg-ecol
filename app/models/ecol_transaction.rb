class EcolTransaction < ActiveRecord::Base
  has_one :ecol_customer, :primary_key => 'customer_code', :foreign_key => 'code'
  has_one :ecol_remitter, :primary_key => 'ecol_remitter_id', :foreign_key => 'id'
  has_many :ecol_audit_logs
  lazy_load :settle_result, :validation_result, :notify_result, :fault_reason
  
  validates_presence_of :status, :transfer_type, :transfer_unique_no, :transfer_status, 
  :transfer_timestamp, :transfer_ccy, :transfer_amt, :rmtr_account_no, :rmtr_account_ifsc,
  :bene_account_no, :bene_account_ifsc, :received_at
  
  validates :transfer_amt, :numericality => { :greater_than => 0 }
  
  def expected_transfer_amt
    if ecol_customer.try(:val_method) == 'D'
      unless ecol_customer.nil?
        if ecol_customer.val_txn_amt == 'E'
          "#{ecol_remitter.invoice_amt rescue "-"}"
        elsif ecol_customer.val_txn_amt == 'R' 
          "between #{ecol_remitter.min_credit_amt rescue "-"} and #{ecol_remitter.max_credit_amt rescue "-"}"
        elsif ecol_customer.val_txn_amt == 'P' 
          "within #{ecol_remitter.invoice_amt_tol_pct rescue "-"}% to #{ecol_remitter.invoice_amt rescue "-"}"
        end
      end
    end
  end

  def expected_transfer_timestamp
    if ecol_customer.try(:val_method) == 'D'
      unless ecol_customer.nil?
        if ecol_customer.val_txn_date == 'E'
          "#{ecol_remitter.due_date rescue "-"}"
        elsif ecol_customer.val_txn_date == 'R' 
          "within #{ecol_remitter.due_date_tol_days rescue "-"} days of #{ecol_remitter.due_date rescue "-"}"
        end
      end
    end
  end
  
  def override(status, user_id, remarks)
    result = plsql.pk_qg_ecol_audit_helper.override_and_enqueue(id, status, user_id, nil, remarks, nil, nil)
    raise ::Fault::ProcedureFault.new(OpenStruct.new(code: result[:po_fault_code], subCode: nil, reasonText: "#{result[:po_fault_reason]}")) if result[:po_fault_code].present?
  end
end
