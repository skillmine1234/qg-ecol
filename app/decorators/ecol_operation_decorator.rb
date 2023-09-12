class EcolOperationDecorator < ApplicationDecorator
  delegate_all
  
  def req_bitstream
    h.render partial: 'shared/bitstream', locals: {id: "#{object.class.name.demodulize}_req_bitstream_#{object.id}", 
      title: "request_message".humanize, 
      bitstream: object.audit_log.req_bitstream, 
      ref_no: object.req_no,
      button: 'd_clip_button1',
      xml: 'req_xml'}
  end
  
  def rep_bitstream
    h.render partial: 'shared/bitstream', locals: {id: "#{object.class.name.demodulize}_rep_bitstream_#{object.id}", 
      title: "reply_message".humanize, 
      bitstream: object.audit_log.rep_bitstream, 
      ref_no: (object.rep_no || 'Show'),
      button: 'd_clip_button2',
      xml: 'rep_xml'}
  end
  
  def txn_amount
    h.number_to_currency(object.txn_amount, unit: 'Rs ')
  end
  
  def hold_amount
    h.number_to_currency(object.hold_amount, unit: 'Rs ')
  end

  def hold_balance
    h.number_to_currency(object.hold_balance, unit: 'Rs ')
  end

  def account_balance
    h.number_to_currency(object.account_balance, unit: 'Rs ')
  end

  def status_code
    h.render partial: 'shared/status', locals: {id: "#{object.class.name.demodulize}_status_code_#{object.id}", object: object}
  end
end
