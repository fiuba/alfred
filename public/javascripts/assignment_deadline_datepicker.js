$(document).ready(function() {
  $('#assignment_deadline').datepicker( { dateFormat: 'dd/mm/yy'} );
  $('#assignment_deadline_button').click( function() {
    $('#assignment_deadline').datepicker("show");
  });
});

