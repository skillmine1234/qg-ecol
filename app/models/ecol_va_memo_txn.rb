class EcolVaMemoTxn < ActiveRecord::Base
  include Approval2::ModelAdditions
  
  TXN_TYPES = ['CREDIT', 'DEBIT']

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  belongs_to :ecol_customer, class_name: 'EcolCustomer', foreign_key: 'customer_code', primary_key: 'code'
  belongs_to :ecol_va_txn
  belongs_to :ecol_va_earmark

  before_validation :get_reference_no, if: "approval_status=='U'"

  validates_uniqueness_of :reference_no, scope: [:approval_status]
  validates_presence_of :reference_no, :account_no, :txn_amount, :txn_type, :customer_code
  validates :account_no, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: { maximum: 64 }
  validates_numericality_of :txn_amount
  validates_numericality_of :hold_no, :hold_amount, allow_blank: true
  validates :txn_desc, length: { maximum: 255 }, :allow_blank => true
  validate :presence_of_ecol_customer
  validates_absence_of :hold_no, :hold_amount, if: "txn_type == 'DEBIT'"
  
  after_save :create_transaction, if: "approval_status=='A' && !Rails.env.test?"

  def get_reference_no
    max_id = EcolVaMemoTxn.unscoped.maximum(:id)
    max_id.nil? ? "REF1" : "REF#{max_id+1}"
  end

  def presence_of_ecol_customer
    errors.add(:customer_code, "Invalid E-Collect Customer Code") if EcolCustomer.find_by(code: customer_code, val_method: 'V').nil?
  end

  def create_transaction
    result = nil
    result = plsql.pk_qg_ecol_va_xface.credit_debit(pi_customer_code: self.customer_code,
                                                    pi_account_no: self.account_no,
                                                    pi_txn_amount: self.txn_amount,
                                                    pi_txn_type: self.txn_type,
                                                    pi_hold_no: self.hold_no,
                                                    pi_hold_amount: self.hold_amount,
                                                    pi_txn_desc: self.txn_desc,
                                                    pi_allow_modify: 'N',
                                                    pi_auditable_type: 'EcolVaMemoTxn',
                                                    pi_auditable_id: self.id.to_s,
                                                    pi_created_by: self.created_by,
                                                    pi_approved_by: self.updated_by,
                                                    po_ecol_va_txn_id_cd: nil,
                                                    po_ecol_va_txn_id_earmark: nil,
                                                    po_fault_code: nil,
                                                    po_fault_subcode: nil,
                                                    po_fault_reason: nil)
    raise Fault::ProcedureFault.new(OpenStruct.new(code: result[1][:po_fault_code], subCode: result[1][:po_fault_subcode], reasonText: "#{result[1][:po_fault_reason]}")) if result.present? && result[1][:po_fault_code].present?
    self.update_columns(ecol_va_txn_id: result[1][:po_ecol_va_txn_id_cd], ecol_va_earmark_id: result[1][:po_ecol_va_txn_id_earmark])
  end
end