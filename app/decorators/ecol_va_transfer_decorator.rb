class EcolVaTransferDecorator < EcolOperationDecorator
  
  def picked_at
    object.picked_at.try(:strftime, "%d/%m/%Y %I:%M%p")
  end
  
  def reconciled_at
    object.reconciled_at.try(:strftime, "%d/%m/%Y %I:%M%p")
  end
    
  def returned_at
    object.returned_at.try(:strftime, "%d/%m/%Y %I:%M%p")
  end
  
  def transfer_amount
    h.number_to_currency(object.transfer_amount, unit: 'Rs ')
  end
  
  def status_code
    h.render partial: 'shared/status', locals: {id: "#{object.class.name.demodulize}_status_code_#{object.id}", object: object}
  end
  
  def rev_unblock_status
    h.render partial: 'ecol_va_transfers/reverse_unblock_status', locals: {id: "#{object.class.name.demodulize}_rev_unblock_status_#{object.id}", object: object}
  end
  
  def steps
    h.link_to 'Show', h.send("steps_ecol_va_transfer_path", object)
  end
end