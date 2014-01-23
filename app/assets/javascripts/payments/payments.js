$(document).ready(function() {
  $(":checkbox").on("change", function(){
    $(this).parent().next().toggle();
  });

  $("form").on("submit", function(){
    var $form = $(this);
    if($form.valid()){
      $form.find(".btn").attr("disabled", true).val("Enviando...");
    }else{
      return false;
    }
  });

});
