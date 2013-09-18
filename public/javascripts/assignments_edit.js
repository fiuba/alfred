$(document).ready(function() {
	$("button.delete-file").click(function(e) {
		e.preventDefault();
 		if (!confirm($(this).attr('data-confirmation'))) {
 			return;
 		}

    var url = $(this).attr('data-url');
		$.ajax(url, {
      beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('input[name="authenticity_token"]').attr('value')) },
      method: 'DELETE',
      success: function(data, textStatus, jqXHR) {
      	$('.assignment-file, .delete-file').css('display', 'none');
      	$('.file').css('display', 'block').removeAttr('disabled');
      },
      error: function(jqXHR, textStatus, errorThrown) {
      	alert('error');
      }
    });
	});
});