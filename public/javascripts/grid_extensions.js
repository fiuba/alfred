function countRows(gridSelector) {
	var rowCount = $(gridSelector + ' tr').filter(function() {
 	return $(this).css('display') != 'none';
 	}).length -1;
 	$('#rowCount').text(rowCount);
 }