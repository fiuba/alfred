$(document).ready(function() {
	
  //$(document).on('click', "#karma-button", function(event) {

	
	$('#karma-button').click( function giveKarma(event) {
			var url = $(this).closest("form").attr("action");
	    event.preventDefault();
	    $.ajax(url, {
	      beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('input[name="authenticity_token"]').attr('value')) },
	      method: 'POST',
	      success: function(data, textStatus, jqXHR) {
	        $('.main-wrapper').html('<div class="alert alert-success fade in">Total karma: ' + data.new_karma + '<button class="close" data-dismiss="alert" type="button">×</button></div>');
					$('#karma-counter').text(data.new_karma);
	      },
	      error: function(jqXHR, textStatus, errorThrown) {
	        $('.main-wrapper').html('<div class="alert alert-error fade in">' + errorThrown + '<button class="close" data-dismiss="alert" type="button">×</button></div>');
				}
			});
		})
	});