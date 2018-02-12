class EcolVaTxnDecorator < EcolOperationDecorator
  def account_no
    h.link_to object.account_no, h.ecol_va_account_path(object.ecol_va_account)
  end
  
  def hold_no
    return '-' if object.hold_no.nil?
    h.link_to object.hold_no, h.ecol_va_earmark_path(object.ecol_va_account)
  end
      
  def txn_type
    h.link_to object.txn_type, h.url_for(:controller => "#{object.auditable_type.constantize.table_name}", :action => "show", :id => object.auditable_id) rescue object.txn_type
  end
  
  def txn_timestamp
    object.txn_timestamp.try(:strftime, "%d/%m/%Y %I:%M%p")
  end
end