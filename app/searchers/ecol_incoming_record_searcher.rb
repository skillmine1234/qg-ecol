class EcolIncomingRecordSearcher < Searcher
  attr_searchable :customer_code, :remitter_code, :invoice_no, :file_name, :status, :overrided_flag

  private

  def find
    reln = EcolIncomingRecord.joins(:incoming_file_record).where("ecol_incoming_records.file_name=? and incoming_file_records.status=?", file_name, status).order("ecol_incoming_records.id desc")
    reln = reln.where("incoming_file_records.overrides is not null") if overrided_flag.present? and overrided_flag == "true"
    reln = reln.where("incoming_file_records.overrides is null") if overrided_flag.present? and overrided_flag == "false"
    reln = reln.where("ecol_incoming_records.customer_code=?",customer_code) if customer_code.present?
    reln = reln.where("ecol_incoming_records.remitter_code=?",remitter_code) if remitter_code.present?
    reln = reln.where("ecol_incoming_records.invoice_no=?",invoice_no) if invoice_no.present?
    reln
  end
end