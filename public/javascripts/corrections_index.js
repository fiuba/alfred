window.onload = function() {
				editableGrid = new EditableGrid("DemoGridAttach"); 

				// we build and load the metadata in Javascript
				editableGrid.load({ metadata: [
					{ name: "tp", datatype: "string" },
					{ name: "padron", datatype: "string" },
					{ name: "nombre", datatype: "string" },
					{ name: "prueba", datatype: "string" },
					{ name: "estado", datatype: "string" },
					{ name: "nota", datatype: "string" },
					{ name: "acciones", datatype: "html" }
				]});

				// then we attach to the HTML table and render it
				editableGrid.attachToHTMLTable('correctionsGrid');

				editableGrid.renderGrid();

		    // filter when something is typed into filter
		    _$('filter').onkeyup = function() { editableGrid.filter(_$('filter').value); };
				
			} 