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

	var DEFAULT_HEIGHT = 600;
	var MAX_HEIGHT = 1080;
	var DEFAULT_WIDTH = 800;
	var MAX_WIDTH = 1920;

    SirTrevor.Blocks.Diagram = (function() {
	
        return SirTrevor.Block.extend({

            type: "diagram",
            title: function() {
                return 'Diagram';
            },
            icon_name: 'image',
            formatable: false,
			textable: false,
			validations: ["codeMustNotBeEmpty","validWidth","validHeight"],

			codeMustNotBeEmpty: function(){
				var code = this.getBlockData().code; //need to send setError a plain js element
				if (code.value === ""){
					this.setError(this.$code_area.get(),"Code area cannot be empty");
				}
			},
			
			validWidth: function(){
				var width = this.getBlockData().width; //need to send setError a plain js element
				if (width <= 0 || width > MAX_WIDTH){
					this.setError(this.$width.get(),"Width must be between 0 and " + MAX_WIDTH);
				}
			},
			
			validHeight: function(){
				var height = this.getBlockData().height; //need to send setError a plain js element
				if (height <= 0 || height > MAX_HEIGHT){
					this.setError(this.$height.get(),"Height must be between 0 and " + MAX_HEIGHT);
				}
			},


			//Updates the object sent to the server
			toData: function(){
				var dataObj = {}
				dataObj.code = this.$code_area.val();
				dataObj.caption = this.$caption.val();
				dataObj.width = this.$height.val();
				dataObj.height = this.$width.val();
				this.setData(dataObj);
			},

            editorHTML: function() {
			   return "<div class='st-svg-inputs'> \
					<div class='form-group'> \
  						<label for='comment'>Enter javascript, css, and html:</label> \
  						<textarea class='st-svg-code  form-control' contenteditable='true' rows='5' id='caption' required></textarea> \
					</div> \
					<div class='form-group'> \
						<label for='width'>Width:</label> \
						<input type='number' min='1' max='" + MAX_WIDTH +"' id='width' required> \
						<label for='height'>Height:</label> \
						<input type='number' min='1' max='" + MAX_HEIGHT +"'  id='height' required> \
						<label for='usr'>Caption:</label> \
  						<input type='text' class='st-svg-caption' id='usr'> \
					</div> \
				</div> \
				<button type='button' class='btn btn-primary st-preview-button'>Preview</button> \
				<div class='st-preview' style='display:none'> \
					<iframe class='st-preview-content'></iframe> \
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

				//Where user enters the caption, width, and height for diagram
				this.$caption = $(this.el).find(".st-svg-caption");
				this.$height = $(this.el).find("#height");
				this.$width = $(this.el).find("#width");
				
				//See preview of diagram
				this.$preview_button = $(this.el).find(".st-preview-button");

				//Container for diagram preview
				this.$preview_area = $(this.el).find(".st-preview");

				//Iframe the diagram is inserted into
				this.$preview_frame = $(this.el).find(".st-preview-content");
				this.$preview_caption = $(this.el).find(".st-preview-caption");
				
				//Check if data has been loaded by sir trevor using the loadData method (code field will exist if it has)
				var preloaded_data = this.getBlockData();
				if ("code" in preloaded_data){
					//add data to inputs and preview area using preloaded_data
					this.setBlock(preloaded_data.code,preloaded_data.caption,preloaded_data.width,preloaded_data.height);
				}
				else {
					//if not loading existing data, set all dimensions to the default
					this.setDimension(DEFAULT_WIDTH,DEFAULT_HEIGHT);
				}

				//User inputs diagram code, update the iframe preview
				this.$code_area.on("change",function(){
					var code = $(this).val();
					this_block.setDiagram(code,this_block.$preview_frame[0]);
				});
				
				//User inputs width or height, update the dimension of the frame and data sent to server
				var dimension_change = function(){ this_block.setDimension(this_block.$width.val(),this_block.$height.val()); }
				this.$width.change(dimension_change);
				this.$height.change(dimension_change);

				//User inputs a caption, update the caption in the preview
				this.$caption.on("change",function(){
					var caption = $(this).val()
					this_block.setCaption(caption);
				});

				this.$preview_button.on("click",function(e){
					e.preventDefault();
					//Show preview of diagram and hide code area
					if (this_block.$preview_area.css("display") == "none"){
						//Display the preview button and hide the input fields
						this_block.$preview_area.css("display","block");
						this_block.$code_area.parent("div").css("display","none");
						$(this).text("Hide Preview");
					}
					//Hide preview and show code area
					else {
						this_block.$preview_area.css("display","none");
						this_block.$code_area.parent("div").css("display","block");
						$(this).text("Preview");
					}
				});

            },

			//used to initialize block with preloaded-data
			setBlock: function(code,caption_text,width,height){
				this.$code_area.val(code);
				this.setDiagram(code);
				this.$caption.val(caption_text);
				this.setCaption(caption_text);
				this.setDimension(width,height);
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
			
			setDimension: function(width,height){
				//add dimensions to input
				this.$width.val(width);
				this.$height.val(height);
				
				//adjust the size of the iframe
				this.$preview_frame.css("height",height);
				this.$preview_frame.css("width",width);
				
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
