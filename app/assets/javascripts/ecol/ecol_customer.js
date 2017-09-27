$(document).ready(function(){
  
  $("#ecol_customer_val_method").on("change",function(){
    var val_method =  $(this).val();
    if (val_method === 'N'){
      $('#ecol_customer_val_token_1').val('N');
      $('#ecol_customer_val_token_1').prop('disabled',true);
      $('#ecol_customer_val_token_2').val('N');
      $('#ecol_customer_val_token_2').prop('disabled',true);
      $('#ecol_customer_val_token_3').val('N');
      $('#ecol_customer_val_token_3').prop('disabled',true);
      $('#ecol_customer_val_txn_date').val('N');
      $('#ecol_customer_val_txn_date').prop('disabled',true);
      $('#ecol_customer_val_txn_amt').val('N');
      $('#ecol_customer_val_txn_amt').prop('disabled',true);
      $('#ecol_customer_val_ben_name').val('N');
      $('#ecol_customer_val_ben_name').prop('disabled',true);
      $('#ecol_customer_val_rem_acct').val('N');
      $('#ecol_customer_val_rem_acct').prop('disabled',true);
      $('#ecol_customer_val_rmtr_name').val('N');
      $('#ecol_customer_val_rmtr_name').prop('disabled',true);
      $('#ecol_customer_val_last_token_length').val('N');
      $('#ecol_customer_val_last_token_length').prop('disabled',true);
      $('#ecol_customer_return_if_val_reject').val('N');
      $('#ecol_customer_return_if_val_reject').prop('disabled',true);
      $("#ecol_customer_file_upld_mthd").val('N');
      $('#ecol_customer_file_upld_mthd').prop('disabled',true);
			$("#ecol_customer_credit_acct_val_fail").val('');
			$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
    }
    else if (val_method === 'W'){
      $('#ecol_customer_file_upld_mthd').val('N');
      $("#ecol_customer_file_upld_mthd").prop('disabled',true);
      $('#ecol_customer_val_txn_date').prop('disabled',false);
      $('#ecol_customer_val_txn_amt').prop('disabled',false);
      $('#ecol_customer_val_ben_name').prop('disabled',false);
      $('#ecol_customer_val_rem_acct').prop('disabled',false);
      $('#ecol_customer_val_rmtr_name').prop('disabled',false);
      $('#ecol_customer_val_last_token_length').prop('disabled',false);
      $('#ecol_customer_return_if_val_reject').prop('disabled',false);
			if ($("#ecol_customer_return_if_val_reject").attr('checked')) {
				$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
			}
			else {
				$('#ecol_customer_credit_acct_val_fail').prop('disabled',false);
			}
			for (i=1; i<=3; i++) {
				if ($('#ecol_customer_token_' + i + '_type').val() === 'SC' || $('#ecol_customer_token_' + i + '_type').val() === 'RC' || $('#ecol_customer_token_' + i + '_type').val() === 'IN'){
          if (!$('#ecol_customer_val_token_' + i).is(":checked")) {
            $('#ecol_customer_val_token_' + i).val('N');
          }
          $('#ecol_customer_val_token_' + i).prop('disabled',false);
				}
			}
    }
    else{
      $('#ecol_customer_val_txn_date').prop('disabled',false);
      $('#ecol_customer_val_txn_amt').prop('disabled',false);
      $('#ecol_customer_val_ben_name').prop('disabled',false);
      $('#ecol_customer_val_rem_acct').prop('disabled',false);
      $('#ecol_customer_val_rmtr_name').prop('disabled',false);
      $('#ecol_customer_val_last_token_length').prop('disabled',false);
      $('#ecol_customer_return_if_val_reject').prop('disabled',false);
      $('#ecol_customer_file_upld_mthd').prop('disabled',false);
			if ($("#ecol_customer_return_if_val_reject").attr('checked')) {
				$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
			}
			else {
				$('#ecol_customer_credit_acct_val_fail').prop('disabled',false);
			}
			for (i=1; i<=3; i++) {
				if ($('#ecol_customer_token_' + i + '_type').val() === 'SC' || $('#ecol_customer_token_' + i + '_type').val() === 'RC' || $('#ecol_customer_token_' + i + '_type').val() === 'IN'){
					$('#ecol_customer_val_token_' + i).prop('disabled',false);
				}
			}
    }

  });
  
  
  if ($('#ecol_customer_val_method').val() === 'N'){
    $('#ecol_customer_val_token_1').val('N');
    $('#ecol_customer_val_token_1').prop('disabled',true);
    $('#ecol_customer_val_token_2').val('N');
    $('#ecol_customer_val_token_2').prop('disabled',true);
    $('#ecol_customer_val_token_3').val('N');
    $('#ecol_customer_val_token_3').prop('disabled',true);
    $('#ecol_customer_val_txn_date').val('N');
    $('#ecol_customer_val_txn_date').prop('disabled',true);
    $('#ecol_customer_val_txn_amt').val('N');
    $('#ecol_customer_val_txn_amt').prop('disabled',true);
    $('#ecol_customer_val_ben_name').val('N');
    $('#ecol_customer_val_ben_name').prop('disabled',true);
    $('#ecol_customer_val_rem_acct').val('N');
    $('#ecol_customer_val_rem_acct').prop('disabled',true);
    $('#ecol_customer_val_rmtr_name').val('N');
    $('#ecol_customer_val_rmtr_name').prop('disabled',true);
    $('#ecol_customer_val_last_token_length').val('N');
    $('#ecol_customer_val_last_token_length').prop('disabled',true);
    $('#ecol_customer_return_if_val_reject').val('N');
    $('#ecol_customer_return_if_val_reject').prop('disabled',true);
    $("#ecol_customer_file_upld_mthd").val('N');
    $('#ecol_customer_file_upld_mthd').prop('disabled',true);
		$("#ecol_customer_credit_acct_val_fail").val('');
		$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
  }
  else if ($('#ecol_customer_val_method').val() === 'W'){
    $('#ecol_customer_file_upld_mthd').val('N');
    $("#ecol_customer_file_upld_mthd").prop('disabled',true);
    $('#ecol_customer_val_txn_date').prop('disabled',false);
    $('#ecol_customer_val_txn_amt').prop('disabled',false);
    $('#ecol_customer_val_ben_name').prop('disabled',false);
    $('#ecol_customer_val_rem_acct').prop('disabled',false);
    $('#ecol_customer_val_rmtr_name').prop('disabled',false);
    $('#ecol_customer_val_last_token_length').prop('disabled',false);
    $('#ecol_customer_return_if_val_reject').prop('disabled',false);
		if ($("#ecol_customer_return_if_val_reject").attr('checked')) {
			$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
		}
		else {
			$('#ecol_customer_credit_acct_val_fail').prop('disabled',false);
		}
		for (i=1; i<=3; i++) {
			if ($('#ecol_customer_token_' + i + '_type').val() === 'SC' || $('#ecol_customer_token_' + i + '_type').val() === 'RC' || $('#ecol_customer_token_' + i + '_type').val() === 'IN'){
				$('#ecol_customer_val_token_' + i).prop('disabled',false);
			}
		}
  }
  else{
    $('#ecol_customer_val_txn_date').prop('disabled',false);
    $('#ecol_customer_val_txn_amt').prop('disabled',false);
    $('#ecol_customer_val_ben_name').prop('disabled',false);
    $('#ecol_customer_val_rem_acct').prop('disabled',false);
    $('#ecol_customer_val_rmtr_name').prop('disabled',false);
    $('#ecol_customer_val_last_token_length').prop('disabled',false);
    $('#ecol_customer_return_if_val_reject').prop('disabled',false);
    $('#ecol_customer_file_upld_mthd').prop('disabled',false);
		if ($("#ecol_customer_return_if_val_reject").attr('checked')) {
			$('#ecol_customer_credit_acct_val_fail').prop('disabled',true);
		}
		else {
			$('#ecol_customer_credit_acct_val_fail').prop('disabled',false);
		}
		for (i=1; i<=3; i++) {
			if ($('#ecol_customer_token_' + i + '_type').val() === 'SC' || $('#ecol_customer_token_' + i + '_type').val() === 'RC' || $('#ecol_customer_token_' + i + '_type').val() === 'IN'){
				$('#ecol_customer_val_token_' + i).prop('disabled',false);
			}
		}
  } 

  $("#ecol_customer_token_1_type").on("change",function(){
    var token_1_type =  $(this).val();
    if (token_1_type === 'N'){
      $('#ecol_customer_val_token_1').val('N');
      $('#ecol_customer_val_token_1').prop('disabled',true);
      $('#ecol_customer_token_1_length').val(0);
      $('#ecol_customer_token_1_length').prop('readOnly',true);
      $('#ecol_customer_token_1_starts_with').val('');
      $('#ecol_customer_token_1_starts_with').prop('readOnly',true);
      $('#ecol_customer_token_1_contains').val('');
      $('#ecol_customer_token_1_contains').prop('readOnly',true);
      $('#ecol_customer_token_1_ends_with').val('');
      $('#ecol_customer_token_1_ends_with').prop('readOnly',true);
    }
    else{
      // $('#ecol_customer_val_token_1').prop('disabled',false);
			if ($('#ecol_customer_val_method').val() == 'N') {
				$('#ecol_customer_val_token_1').val('N');
				$('#ecol_customer_val_token_1').prop('disabled',true);
			}
			else {
				$('#ecol_customer_val_token_1').prop('disabled',false);
			}
      $('#ecol_customer_token_1_length').prop('readOnly',false);
      $('#ecol_customer_token_1_starts_with').prop('readOnly',false);
      $('#ecol_customer_token_1_contains').prop('readOnly',false);
      $('#ecol_customer_token_1_ends_with').prop('readOnly',false);
    }
  });
  
  if ($('#ecol_customer_token_1_type').val() === 'N'){
    $('#ecol_customer_val_token_1').prop('disabled',true);
    $('#ecol_customer_token_1_length').val(0);
    $('#ecol_customer_token_1_length').prop('readOnly',true);
    $('#ecol_customer_token_1_starts_with').val('');
    $('#ecol_customer_token_1_starts_with').prop('readOnly',true);
    $('#ecol_customer_token_1_contains').val('');
    $('#ecol_customer_token_1_contains').prop('readOnly',true);
    $('#ecol_customer_token_1_ends_with').val('');
    $('#ecol_customer_token_1_ends_with').prop('readOnly',true);
  }
  else{
    // $('#ecol_customer_val_token_1').prop('disabled',false);
		if ($('#ecol_customer_val_method').val() === 'N') {
			$('#ecol_customer_val_token_1').val('N');
			$('#ecol_customer_val_token_1').prop('disabled',true);
		}
		else {
			$('#ecol_customer_val_token_1').prop('disabled',false);
		}
    $('#ecol_customer_token_1_length').prop('readOnly',false);
    $('#ecol_customer_token_1_starts_with').prop('readOnly',false);
    $('#ecol_customer_token_1_contains').prop('readOnly',false);
    $('#ecol_customer_token_1_ends_with').prop('readOnly',false);
  }
  
  $("#ecol_customer_token_2_type").on("change",function(){
    var token_2_type =  $(this).val();
    if (token_2_type === 'N'){
      $('#ecol_customer_val_token_2').val('N');
      $('#ecol_customer_val_token_2').prop('disabled',true);
      $('#ecol_customer_token_2_length').val(0);
      $('#ecol_customer_token_2_length').prop('readOnly',true);
      $('#ecol_customer_token_2_starts_with').val('');
      $('#ecol_customer_token_2_starts_with').prop('readOnly',true);
      $('#ecol_customer_token_2_contains').val('');
      $('#ecol_customer_token_2_contains').prop('readOnly',true);
      $('#ecol_customer_token_2_ends_with').val('');
      $('#ecol_customer_token_2_ends_with').prop('readOnly',true);
    }
    else{
      // $('#ecol_customer_val_token_2').prop('disabled',false);
			if ($('#ecol_customer_val_method').val() === 'N') {
				$('#ecol_customer_val_token_2').val('N');
				$('#ecol_customer_val_token_2').prop('disabled',true);
			}
			else {
				$('#ecol_customer_val_token_2').prop('disabled',false);
			}
      $('#ecol_customer_token_2_length').prop('readOnly',false);
      $('#ecol_customer_token_2_starts_with').prop('readOnly',false);
      $('#ecol_customer_token_2_contains').prop('readOnly',false);
      $('#ecol_customer_token_2_ends_with').prop('readOnly',false);
    }
  });
  
  if ($('#ecol_customer_token_2_type').val() === 'N'){
    $('#ecol_customer_val_token_2').prop('disabled',true);
    $('#ecol_customer_token_2_length').val(0);
    $('#ecol_customer_token_2_length').prop('readOnly',true);
    $('#ecol_customer_token_2_starts_with').val('');
    $('#ecol_customer_token_2_starts_with').prop('readOnly',true);
    $('#ecol_customer_token_2_contains').val('');
    $('#ecol_customer_token_2_contains').prop('readOnly',true);
    $('#ecol_customer_token_2_ends_with').val('');
    $('#ecol_customer_token_2_ends_with').prop('readOnly',true);
  }
  else{
    // $('#ecol_customer_val_token_2').prop('disabled',false);
		if ($('#ecol_customer_val_method').val() === 'N') {
			$('#ecol_customer_val_token_2').val('N');
			$('#ecol_customer_val_token_2').prop('disabled',true);
		}
		else {
			$('#ecol_customer_val_token_2').prop('disabled',false);
		}
    $('#ecol_customer_token_2_length').prop('readOnly',false);
    $('#ecol_customer_token_2_starts_with').prop('readOnly',false);
    $('#ecol_customer_token_2_contains').prop('readOnly',false);
    $('#ecol_customer_token_2_ends_with').prop('readOnly',false);
  }
  
  $("#ecol_customer_token_3_type").on("change",function(){
    var token_3_type =  $(this).val();
    if (token_3_type === 'N'){
      $('#ecol_customer_val_token_3').val('N');
      $('#ecol_customer_val_token_3').prop('disabled',true);
      $('#ecol_customer_token_3_length').val(0);
      $('#ecol_customer_token_3_length').prop('readOnly',true); 
      $('#ecol_customer_token_3_length').prop('readOnly',true);
      $('#ecol_customer_token_3_starts_with').val('');
      $('#ecol_customer_token_3_starts_with').prop('readOnly',true);
      $('#ecol_customer_token_3_contains').val('');
      $('#ecol_customer_token_3_contains').prop('readOnly',true);
      $('#ecol_customer_token_3_ends_with').val('');
      $('#ecol_customer_token_3_ends_with').prop('readOnly',true);
    }
    else{
      // $('#ecol_customer_val_token_3').prop('disabled',false);
			if ($('#ecol_customer_val_method').val() === 'N') {
				$('#ecol_customer_val_token_3').val('N');
				$('#ecol_customer_val_token_3').prop('disabled',true);
			}
			else {
				$('#ecol_customer_val_token_3').prop('disabled',false);
			}
      $('#ecol_customer_token_3_length').prop('readOnly',false);
      $('#ecol_customer_token_3_starts_with').prop('readOnly',false);
      $('#ecol_customer_token_3_contains').prop('readOnly',false);
      $('#ecol_customer_token_3_ends_with').prop('readOnly',false);
    }
  });
  
  if ($('#ecol_customer_token_3_type').val() === 'N'){
    $('#ecol_customer_val_token_3').prop('disabled',true);
    $('#ecol_customer_token_3_length').val(0);
    $('#ecol_customer_token_3_length').prop('readOnly',true);
    $('#ecol_customer_token_3_starts_with').val('');
    $('#ecol_customer_token_3_starts_with').prop('readOnly',true);
    $('#ecol_customer_token_3_contains').val('');
    $('#ecol_customer_token_3_contains').prop('readOnly',true);
    $('#ecol_customer_token_3_ends_with').val('');
    $('#ecol_customer_token_3_ends_with').prop('readOnly',true);
  }
  else{
    // $('#ecol_customer_val_token_3').prop('disabled',false);
		if ($('#ecol_customer_val_method').val() == 'N') {
			$('#ecol_customer_val_token_3').val('N');
			$('#ecol_customer_val_token_3').prop('disabled',true);
		}
		else {
			$('#ecol_customer_val_token_3').prop('disabled',false);
		}
    $('#ecol_customer_token_3_length').prop('readOnly',false);
    $('#ecol_customer_token_3_starts_with').prop('readOnly',false);
    $('#ecol_customer_token_3_contains').prop('readOnly',false);
    $('#ecol_customer_token_3_ends_with').prop('readOnly',false);
  }
  
  
  $("#ecol_customer_val_method").on("change",function(){
    var val_method =  $(this).val();
    for (var i=1; i<=3; i++){
      if (val_method == 'N' || val_method == 'W'){
        $("#ecol_customer_nrtv_sufx_" + i).val('N');
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="SC"]').prop("disabled",true);
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RC"]').prop("disabled",true);
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="IN"]').prop("disabled",true);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RN"]').prop("disabled",true);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF1"]').prop("disabled",true);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF2"]').prop("disabled",true);
      }
      else {
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="SC"]').prop("disabled",false);
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RC"]').prop("disabled",false);
        // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="IN"]').prop("disabled",false);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RN"]').prop("disabled",false);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF1"]').prop("disabled",false);
        $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF2"]').prop("disabled",false);
      }
    }
  });  
  
  for (var i=1; i<=3; i++){
    if ($('#ecol_customer_val_method').val() == 'N' || $('#ecol_customer_val_method').val() == 'W'){
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="SC"]').prop("disabled",true);
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RC"]').prop("disabled",true);
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="IN"]').prop("disabled",true);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RN"]').prop("disabled",true);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF1"]').prop("disabled",true);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF2"]').prop("disabled",true);
    }
    else {
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="SC"]').prop("disabled",false);
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RC"]').prop("disabled",false);
      // $("#ecol_customer_nrtv_sufx_" + i).children('option[value="IN"]').prop("disabled",false);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="RN"]').prop("disabled",false);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF1"]').prop("disabled",false);
      $("#ecol_customer_nrtv_sufx_" + i).children('option[value="UDF2"]').prop("disabled",false);   
    }
  }
  
  $("#ecol_customer_rmtr_alert_on").on("change",function(){
    var rmtr_alert =  $(this).val();
    if (rmtr_alert == 'P') {
      $("#ecol_customer_rmtr_return_txt").val('');
      $("#ecol_customer_rmtr_return_txt").prop("disabled",true);
      $("#ecol_customer_rmtr_pass_txt").prop("disabled",false);
    }
    else if (rmtr_alert == 'R') {
      $("#ecol_customer_rmtr_pass_txt").val('');
      $("#ecol_customer_rmtr_pass_txt").prop("disabled",true);
      $("#ecol_customer_rmtr_return_txt").prop("disabled",false);
    }
    else if (rmtr_alert == 'N') {
      $("#ecol_customer_rmtr_pass_txt").prop("disabled",true);
      $("#ecol_customer_rmtr_return_txt").prop("disabled",true);
    }
    else {
      $("#ecol_customer_rmtr_return_txt").prop("disabled",false);
      $("#ecol_customer_rmtr_pass_txt").prop("disabled",false);
    }
  });
  
  if ($("#ecol_customer_rmtr_alert_on").val() == 'P') {
    $("#ecol_customer_rmtr_return_txt").val('');
    $("#ecol_customer_rmtr_return_txt").prop("disabled",true);
    $("#ecol_customer_rmtr_pass_txt").prop("disabled",false);
  }
  else if ($("#ecol_customer_rmtr_alert_on").val() == 'R') {
    $("#ecol_customer_rmtr_pass_txt").val('');
    $("#ecol_customer_rmtr_pass_txt").prop("disabled",true);
    $("#ecol_customer_rmtr_return_txt").prop("disabled",false);
  }
  else if ($("#ecol_customer_rmtr_alert_on").val() == 'N') {
    $("#ecol_customer_rmtr_pass_txt").prop("disabled",true);
    $("#ecol_customer_rmtr_return_txt").prop("disabled",true);
  }
  else {
    $("#ecol_customer_rmtr_return_txt").prop("disabled",false);
    $("#ecol_customer_rmtr_pass_txt").prop("disabled",false);
  }
  
  if ($('#ecol_customer_return_if_val_reject').attr('checked')) {
    $("#ecol_customer_credit_acct_val_fail").val('');
    $("#ecol_customer_credit_acct_val_fail").prop("disabled",true);
    $("#ecol_customer_debit_acct_val_fail").prop("disabled",false);
  }
  else {
    $("#ecol_customer_debit_acct_val_fail").prop("disabled",false);
    $("#ecol_customer_debit_acct_val_fail").val('');
    $("#ecol_customer_debit_acct_val_fail").prop("disabled",true);
  }
  
  $("#ecol_customer_return_if_val_reject").on("click",function(){
    if ($(this).attr('checked')) {
      $("#ecol_customer_credit_acct_val_fail").val('');
      $("#ecol_customer_credit_acct_val_fail").prop("disabled",true);
      $("#ecol_customer_debit_acct_val_fail").prop("disabled",false);
    }
    else {
      $("#ecol_customer_credit_acct_val_fail").prop("disabled",false);
      $("#ecol_customer_debit_acct_val_fail").val('');
      $("#ecol_customer_debit_acct_val_fail").prop("disabled",true);
    }
  });
  
  $('#ecol_customer_allowed_operations').multiselect({selectedList: 4});
  
  $('#ecol_customer_form').bind('submit', function() {
      $(this).find(':input').removeAttr('disabled');
  });
});