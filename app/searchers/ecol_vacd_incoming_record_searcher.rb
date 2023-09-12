class EcolVacdIncomingRecordSearcher < Searcher
  attr_searchable :account_no, :txn_type, :file_name, :status, :overrided_flag

  private

  def find
    reln = EcolVacdIncomingRecord.joins(:incoming_file_record).where("ecol_vacd_incoming_records.file_name=? and incoming_file_records.status=?", file_name, status).order("ecol_vacd_incoming_records.id desc")
    reln = reln.where("incoming_file_records.overrides is not null") if overrided_flag.present? and overrided_flag == "true"
    reln = reln.where("incoming_file_records.overrides is null") if overrided_flag.present? and overrided_flag == "false"
    reln = reln.where("ecol_vacd_incoming_records.account_no=?",account_no) if account_no.present?
    reln = reln.where("ecol_vacd_incoming_records.txn_type=?",txn_type) if txn_type.present?
    reln
  end
end