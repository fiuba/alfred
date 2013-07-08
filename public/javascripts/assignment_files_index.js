$("form.delete-form").submit(function() {
	return confirm($(this).attr('data-confirmation'));
});