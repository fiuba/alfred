$(document).ready(function() {
  // TODO: Localize strings
  editableGrid = new EditableGrid('correctionsGrid', {
    shortMonthNames: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
  });

  // we build and load the metadata in Javascript
  editableGrid.load({ metadata: [
    { name: "Turno", datatype: "string" },
    { name: "Nombre", datatype: "string" },
    { name: "Fecha de entrega", datatype: "date" },
    { name: "Estado", datatype: "string" },
    { name: "Corrector", datatype: "string" },
    { name: "Acciones", datatype: "html", editable: false }
  ]});

  // then we attach to the HTML table and render it
  editableGrid.attachToHTMLTable('correctionsGrid');

  editableGrid.renderGrid();

  $("[rel='tooltip']").tooltip();

  // filter when something is typed into filter
  _$('filter').onkeyup = function() { editableGrid.filter(_$('filter').value); };

  $(".assign-to-me").click(function(e) {
    var url = $(this).closest("form").attr("action");
    var actionsCell = $(this).closest("form").closest('td');
    var teacher_assigned_cell = $(this).closest("tr").find('td.teacher_assigned');
    var status_cell = $(this).closest("tr").find('td.status');
    e.preventDefault();
    $.ajax(url, {
      beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('input[name="authenticity_token"]').attr('value')) },
      method: 'POST',
      success: function(data, textStatus, jqXHR) {
        $('.main-wrapper').html('<div class="alert alert-success fade in">' + data.message + '<button class="close" data-dismiss="alert" type="button">×</button></div>');
        teacher_assigned_cell.html(data.assigned_teacher);
        status_cell.html(data.new_status);

        disableAssignToMeAction(actionsCell);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        $('.main-wrapper').html('<div class="alert alert-error fade in">' + errorThrown + '<button class="close" data-dismiss="alert" type="button">×</button></div>');
      }
    });
  });
});

function disableAssignToMeAction(actionsCell) {
  var disabledAssignToMeElement = $('<span/>', {
    class: 'list-row-action-wrapper-link',
    'data-original-title': $('.assign-to-me', actionsCell).attr('data-original-title'),
    rel: 'tooltip'
  }).append(
    $('<i/>', {
      class: 'icon-user'
    })
  );
  actionsCell.prepend(disabledAssignToMeElement);

  $('form', actionsCell).remove();
  $("[rel='tooltip']").tooltip();
}
