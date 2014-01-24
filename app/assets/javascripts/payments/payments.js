$(document).ready(function() {
  $(":checkbox").on("change", function(){
    $(this).parent().next().toggle();
  });

  $("form").on("submit", function(){
    var $form = $(this);
    validate_voucher($form)
    if($form.valid()){
      $form.find(".btn").attr("disabled", true).val("Enviando...");
    }else{
      return false;
    }
  });

  function validate_voucher($form){
    var voucher_input = $($form).find("#payment_voucher");
    var amount = $($form).find("#payment_amount").val();
    var voucher = voucher_input.val();
    if (amount > 0 && (voucher == null || voucher == ""))
     voucher_input.addClass("required")
   else
     voucher_input.removeClass("required")
  }
});
