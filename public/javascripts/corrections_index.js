window.onload = function() {
				editableGrid = new EditableGrid("DemoGridAttach"); 

				// we build and load the metadata in Javascript
				editableGrid.load({ metadata: [
					{ name: "File", datatype: "html" },
					{ name: "Assingment", datatype: "string" },
				]});

				// then we attach to the HTML table and render it
				editableGrid.attachToHTMLTable('correctionsGrid');

				editableGrid.renderGrid();

			} 
