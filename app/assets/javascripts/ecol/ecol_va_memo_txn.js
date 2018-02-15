$(document).ready(function(){

  $("#ecol_va_memo_txn_txn_type").on("change",function(){
    var txn_type =  $(this).val();
    if (txn_type == 'DEBIT'){
      $('#ecol_va_memo_txn_hold_no').val('');
      $('#ecol_va_memo_txn_hold_no').prop('readOnly',true);
      $('#ecol_va_memo_txn_hold_amount').val('');
      $('#ecol_va_memo_txn_hold_amount').prop('readOnly',true);
    }
    else{
      $('#ecol_va_memo_txn_hold_no').prop('readOnly',false);
      $('#ecol_va_memo_txn_hold_amount').prop('readOnly',false);
    }
  });

  if ($('#ecol_va_memo_txn_txn_type').val() == 'DEBIT'){
    $('#ecol_va_memo_txn_hold_no').val('');
    $('#ecol_va_memo_txn_hold_no').prop('readOnly',true);
    $('#ecol_va_memo_txn_hold_amount').val('');
    $('#ecol_va_memo_txn_hold_amount').prop('readOnly',true);
  }
  else{
    $('#ecol_va_memo_txn_hold_no').prop('readOnly',false);
    $('#ecol_va_memo_txn_hold_amount').prop('readOnly',false);
  }
  
});