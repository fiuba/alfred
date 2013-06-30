// $("a[data-action='delete']").click(function() {
// 	$.ajax({
//       type: 'DELETE',
//       url: $(this).attr('href'),
//    		error: function(jqXHR, textStatus, errorThrown) {
//       	alert(textStatus);
//       }
//   });
// });

// Confirm before deleting one item
// $('.list-row-action-delete-one').on('click', function(ev) {
//   ev.preventDefault();
//   $(this).addClass('list-row-action-wrapper-link-active')
//     .siblings('.list-row-action-popover-delete-one').first().show()
//     .find('.cancel').on('click', function() {

//       $(this).parents('.list-row-action-popover-delete-one').hide()
//         .siblings('.list-row-action-delete-one').removeClass('list-row-action-wrapper-link-active');
//     });
// });

$("form.delete-form").submit(function() {
	return confirm($(this).attr('data-confirmation'));
});