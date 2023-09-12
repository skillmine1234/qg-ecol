$(document).ready(function(){
  
  $("input#select_all").on("change",function(){
    $('.txn_select').prop("checked", $(this).prop("checked"));
  });
  $('.txn_select').prop("checked", $(this).prop("checked"));
   
  $(".credit-link").on("click", function () {
    var c_status = $(this).data('credit-status');
    var c_result = $(this).data('credit-result');
    $(".credit_status").text(c_status);
    $(".credit_result").text(c_result);
    $('#creditText').modal();
  });

  
  $(".settle-link").on("click", function () {
    var s_result = $(this).data('settle-result');
    display_beautified_data(s_result, ".settle_result", "#settleText");
  });

  $(".validation-link").on("click", function () {
    var v_result = $(this).data('validation-result');
    display_beautified_data(v_result, ".validation_result", "#validationText");
  });
  
  $(".return-link").on("click", function () {
    var r_result = $(this).data('return-result');
    display_beautified_data(r_result, ".return_result", "#returnText");
  });
  

  $(".settle-result").on("click", function () {
    $('#settleResult').modal();
  });

  $(".notify-result").on("click", function () {
    $('#notifyResult').modal();
  });

  $(".ecol_transaction").submit(function(){
    $("#transition_button").prop('disabled', true);
  });

  $("#submit_transaction1").click(function(){
    $('input#status').val('VALIDATION FAILED');
    $('input#approval').val('N');
    $("#update_transactions").submit(function(){
      $("#submit_transaction1").prop('disabled', true);
    });
  });

  $("#submit_transaction2").click(function(){
    $('input#status').val('PENDING RETURN');
    $('input#approval').val('Y');
    $("#update_transactions").submit(function(){
      $("#submit_transaction2").prop('disabled', true);
    });
  });

  $("#submit_transaction3").click(function(){
    $('input#status').val('PENDING CREDIT');
    $('input#approval').val('Y');
    $("#update_transactions").submit(function(){
      $("#submit_transaction3").prop('disabled', true);
    });
  });

  $("#submit_transaction4").click(function(){
    $('input#status').val('RETURN FAILED');
    $('input#approval').val('N');
    $("#update_transactions").submit(function(){
      $("#submit_transaction4").prop('disabled', true);
    });
  });

  $("#submit_transaction5").click(function(){
    $('input#status').val('CREDIT FAILED');
    $('input#approval').val('N');
    $("#update_transactions").submit(function(){
      $("#submit_transaction5").prop('disabled', true);
    });
  });

  $("#submit_transaction6").click(function(){
    $('input#settle_status').val('SETTLEMENT FAILED');
    $('input#approval').val('N');
    $("#update_transactions").submit(function(){
      $("#submit_transaction6").prop('disabled', true);
    });
  });

  $("#submit_transaction7").click(function(){
    $('input#notify_status').val('NOTIFICATION FAILED');
    $('input#approval').val('N');
    $("#update_transactions").submit(function(){
      $("#submit_transaction7").prop('disabled', true);
    });
  });
});