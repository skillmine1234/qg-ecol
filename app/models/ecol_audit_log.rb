class EcolAuditLog < ActiveRecord::Base
  lazy_load :req_bitstream, :rep_bitstream, :fault_bitstream, :req_header, :rep_header
end