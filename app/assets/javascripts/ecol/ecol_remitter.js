$(document).ready(function(){
  
  $("#ecol_remitter_due_date").datepicker(
  {
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    yearRange: "-70:+70"
  });
  
  $('#ecol_remitter_due_date').datepicker("setDate", $('#ecol_remitter_due_date').val());
  
  $("#ecol_remitter_due_date").prop("readOnly",true);
  
  $("#ecol_remitter_customer_subcode").on("change",function(){
    var customer_subcode =  $(this).val();
    if (customer_subcode == ''){
      $('#ecol_remitter_customer_subcode_email').val('');
      $('#ecol_remitter_customer_subcode_email').prop('readOnly',true);
      $('#ecol_remitter_customer_subcode_mobile').val('');
      $('#ecol_remitter_customer_subcode_mobile').prop('readOnly',true);
    }
    else{
      $('#ecol_remitter_customer_subcode_email').prop('readOnly',false);
      $('#ecol_remitter_customer_subcode_mobile').prop('readOnly',false);
    }
  });
  
  if ($('#ecol_remitter_customer_subcode').val() == ''){
    $('#ecol_remitter_customer_subcode_email').val('');
    $('#ecol_remitter_customer_subcode_email').prop('readOnly',true);
    $('#ecol_remitter_customer_subcode_mobile').val('');
    $('#ecol_remitter_customer_subcode_mobile').prop('readOnly',true);
  }
  else{
    $('#ecol_remitter_customer_subcode_email').prop('readOnly',false);
    $('#ecol_remitter_customer_subcode_mobile').prop('readOnly',false);
  }
  
});