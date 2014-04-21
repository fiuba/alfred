$(document).ready(function() {
	$('.test-output').click( function onInfoClick() {
			var data = $(this).attr('data-content');
			$('#testOutput').text(data);
			$('#myModal').modal('show');
		});
});