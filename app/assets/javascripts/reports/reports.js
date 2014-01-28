;
$(function(){
  var dateFormat  = 'yyyy-mm-dd',
      $from       = $('#report_from'),
      $to         = $('#report_to'),
      current_date = new Date().valueOf(),
      from_date, to_date;

  from_date = $from.datepicker({
                format: dateFormat,
                onRender: function(date){
                  return date.valueOf() > current_date ? 'disabled' : '';
                }
              }).on('changeDate', function(e){
                var newDate = new Date(e.date)
                newDate.setDate(newDate.getDate());
                to_date.setValue(newDate);
                from_date.hide();
                $to.get(0).focus();
              }).data('datepicker');

  to_date =   $to.datepicker({
                format: dateFormat,
                onRender: function(date){
                  return (date.valueOf() > current_date) || (date.valueOf() <= from_date.date.valueOf()) ? 'disabled' : '';
                }
              }).on('changeDate', function(e){
                to_date.hide();
              }).data('datepicker');

});