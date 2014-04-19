$(document).ready(function() {
	$('.icon-info-sign').click( function click() {
			var data = $(this).attr('data-content');
			//alert(data);
			var options = {};
			$('#testOutput').text(data);
			$('#myModal').modal('show');
		});
});