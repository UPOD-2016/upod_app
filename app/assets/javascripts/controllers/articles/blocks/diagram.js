/*
 * SirTrevor implementation for the Diagram block.
 * This is intended for inserting svg diagrams 
 * into articles but it can also insert custom
 * html, css, and javascript. The code entered 
 * will be rendered in a sandboxed iframe which
 * restricts the functionality of their javascript.
 * 
 * author: Steven Swartz
*/

//= require includes/sir-trevor
$(document).ready(function() {
    SirTrevor.Blocks.Diagram = (function() {
	
        return SirTrevor.Block.extend({

            type: "diagram",
            title: function() {
                return 'Diagram';
            },
            icon_name: 'image',
            formatable: false,
			textable: false,
			validations: ["codeMustNotBeEmpty"],

			codeMustNotBeEmpty: function(){
				var code = this.$code_area[0]; //need to send setError a plain js element
				if (code.value === ""){
					this.setError(code,"Code area cannot be empty");
				}
			},


			//Updates the object sent to the server
			toData: function(){
				var dataObj = {}
				dataObj.code = this.$code_area.val();
				dataObj.caption = this.$caption.val();
				this.setData(dataObj);
			},

            editorHTML: function() {
			   return "<div class='st-svg-inputs'> \
					<div class='form-group'> \
  						<label for='comment'>Enter javascript, css, and html:</label> \
  						<textarea class='st-svg-code form-control' contenteditable='true' rows='5' id='comment'></textarea> \
					</div> \
					<div class='form-group'> \
  						<label for='usr'>Add a caption:</label> \
  						<input type='text' class='st-svg-caption form-control' id='usr'> \
					</div> \
				</div> \
				<button type='button' class='btn btn-primary st-preview-button'>Preview</button> \
				<div class='st-preview' style='display:none'> \
					<iframe class='st-preview-content' height='580' width='100%'></iframe> \
					<p class='st-preview-caption'></p> \
				</div>";
            },


			/* DOM elements are stored as variables
			 * Fields are populated with any data passed to the loadData function when this block was initalized by sir trevor
			 * Events are added to inputs to update the preview and data object sent to server
			 * Events added to toggle preview of the diagram
			*/
            onBlockRender: function() {
				var this_block = this;

				//User inputs (code_area and caption)
				this.$inputs = $(this.el).find(".st-svg-inputs");

				//Where user enters the diagram code
				this.$code_area = $(this.el).find(".st-svg-code");

				//Where user enters the caption for diagram
				this.$caption = $(this.el).find(".st-svg-caption");

				//See preview of diagram
				this.$preview_button = $(this.el).find(".st-preview-button");

				//Container for diagram preview
				this.$preview_area = $(this.el).find(".st-preview");

				//Iframe the diagram is inserted into
				this.$preview_frame = $(this.el).find(".st-preview-content");
				this.$preview_caption = $(this.el).find(".st-preview-caption");

				//Check if data has been loaded by sir trevor using the loadData method
				var preloaded_data = this.getBlockData();
				if (!jQuery.isEmptyObject(preloaded_data)){
					//add data to inputs and preview area using preloaded_data
					this.setBlock(preloaded_data.code,preloaded_data.caption);
				}

				//User inputs diagram code, update the iframe preview
				this.$code_area.on("change",function(){
					var code = $(this).val();
					this_block.setDiagram(code,this_block.$preview_frame[0]);
				});

				//User inputs a caption, update the caption in the preview
				this.$caption.on("change",function(){
					var caption = $(this).val()
					this_block.setCaption(caption);
				});

				this.$preview_button.on("click",function(e){
					e.preventDefault();
					//Show preview of code and hide inputs
					if (this_block.$preview_area.css("display") == "none"){
						//Display the preview button and hide the input fields
						this_block.$preview_area.css("display","block");
						this_block.$inputs.css("display","none");
						$(this).text("Edit");
					}
					//Hide preview and show inputs
					else {
						this_block.$preview_area.css("display","none");
						this_block.$inputs.css("display","block");
						$(this).text("Preview");
					}
				});

            },

			//used to initialize block with preloaded-data
			setBlock: function(code,caption_text){
				this.$code_area.val(code);
				this.setDiagram(code);
				this.$caption.val(caption_text);
				this.setCaption(caption_text);
			},

			setDiagram: function(html){
				//write the html into the iframe preview
				var doc = this.$preview_frame[0].contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();

				//Update object sent to server
				this.toData();
			},

			setCaption: function(caption_text){
				//add a caption below the diagram
				this.$preview_caption.text(caption_text);
				//Update object sent to server
				this.toData();
			}
        })
    })(jQuery);
});
