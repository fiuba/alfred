$(document).ready(function() {
	$('.icon-info-sign').click( function onInfoClick() {
			var data = $(this).attr('data-content');
			$('#testOutput').text(data);
			$('#myModal').modal('show');
		});
});