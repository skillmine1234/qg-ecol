class EcolVaTransfer < ActiveRecord::Base
  include SearchAbility
  
  has_many :audit_steps, class_name: 'EcolVaAuditStep', :as => :ecol_auditable

  attr_searchable :account_no, :transfer_type, {transfer_amount: :range}, :status_code, {req_timestamp: :range}

  as_enum :status_code, [:FAILED, :RETURNED_FROM_BENEFICIARY, :NEW, :SENT_TO_BENEFICIARY, :IN_PROCESS, :COMPLETED], map: :string, source: :status_code
  as_enum :rev_unblock_status, [:FAILED, :COMPLETED], map: :string, source: :rev_unblock_status
  as_enum :transfer_type, [:FT, :NEFT, :RTGS, :IMPS], map: :string, source: :transfer_type
end