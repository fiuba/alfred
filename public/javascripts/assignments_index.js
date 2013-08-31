$(document).ready(function() {
	// TODO: Localize strings
  editableGrid = new EditableGrid('assignmentsGrid', {
    shortMonthNames: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
  });

  // we build and load the metadata in Javascript
  editableGrid.load({ metadata: [
    { name: "Nombre", datatype: "string" },
    { name: "Fecha Límite", datatype: "date", formattedDate: 'dd/mm/YYYY' },
    { name: "Acciones", datatype: "html", editable: false }
  ]});

  // then we attach to the HTML table and render it
  editableGrid.attachToHTMLTable('assigmentsGrid');

  editableGrid.renderGrid();
});

$("form.delete-form").submit(function() {
	return confirm($(this).attr('data-confirmation'));
});