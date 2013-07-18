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
    { name: "Corrector", datatype: "string" }]});

	// then we attach to the HTML table and render it
	editableGrid.attachToHTMLTable('correctionsGrid');

	editableGrid.renderGrid();

	// filter when something is typed into filter
  _$('filter').onkeyup = function() { editableGrid.filter(_$('filter').value); };
});