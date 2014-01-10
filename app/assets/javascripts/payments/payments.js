$(document).ready(function() {
  $(':checkbox').each(function(index,checkbox){
    $(checkbox).on('change', function(){
      id = $(this).attr('data-familyid');
      $('#deposit_number_' + id ).toggle();
      deposit = $('#deposit_number_' + id + ' input:first');
      deposit.val('');
    });
  });

  $(':submit').each(function(index, button){
      $(button).click(function(event) {
      $(this).closest('form').valid();
    })
  })
});
