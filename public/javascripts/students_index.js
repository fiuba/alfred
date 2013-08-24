window.onload = function() {
				editableGrid = new EditableGrid("DemoGridAttach"); 

				// we build and load the metadata in Javascript
				editableGrid.load({ metadata: [
					{ name: "Padron", datatype: "string" },
					{ name: "Nombre", datatype: "string" },
					{ name: "Email", datatype: "string" },
					{ name: "Turno", datatype: "string" }
				]});

				// then we attach to the HTML table and render it
				editableGrid.attachToHTMLTable('studentsGrid');

				editableGrid.renderGrid();

		    // filter when something is typed into filter
		    _$('filter').onkeyup = function() { editableGrid.filter(_$('filter').value); };
				
			} 