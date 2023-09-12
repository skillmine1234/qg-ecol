$(document).ready(function(){
  
  $('#ecol_app_udtable_app_code').prop('disabled', true);
  
  function get_ecol_app(code) {
    $.ajax({
       url: "/ecol_app_udtables/udfs/"+code,
       dataType: "script"
    });
  }

  $('#ecol_app_udtable_app_code').on('change',function(){
    get_ecol_app($('#ecol_app_udtable_app_code').val());
  });

  $('#ecol_app_udtable_form').bind('submit', function() {
    $(this).find(':input').removeAttr('disabled');
  });
});