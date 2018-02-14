class EcolVaAuditStep < ApplicationRecord
  belongs_to :ecol_auditable, :polymorphic => true
  
  attr_accessor :remote_host, :req_uri
  
  lazy_load :req_bitstream, :rep_bistream
  
  as_enum :status_code, [:FAILED, :RETURNED_FROM_BENEFICIARY, :NEW, :SENT_TO_BENEFICIARY, :IN_PROCESS, :COMPLETED], map: :string, source: :status_code
end
