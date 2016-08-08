/*
 * This is a SirTrevor block for adding text and in-line MathJax expressions
 * to articles. Text surrounded with back-ticks will be rendered by MathJax.
 *
 * author: Steven Swartz
*/

//= require includes/sir-trevor
$(document).ready(function() {
    SirTrevor.Blocks.EquationText = (function() {

        return SirTrevor.Block.extend({

            type: "equation_text",
            title: function() {
                return 'Text';
            },

            icon_name: 'text',
            toolbarEnabled: true,
			textable: false,
            paste_options: { html: null },

			//Extracts and sets data that will be sent to the server
			toData: function(){
				var objData = {};
				//Replace \n tags with <br>, potentially leaving other html tags which sir trevor should safely display
				//http://stackoverflow.com/questions/13762863/contenteditable-field-to-maintain-newlines-upon-database-entry
				objData.text = this.$text_area.html().trim()
					.replace(/<br(\s*)\/*>/ig, '\n') // replace single line-breaks
				this.setData(objData);
			},

			//Will populate the block/fields with pre-loaded data
			setBlock: function(data){
				this.$text_area.text(data.text);
			},

            editorHTML: function() {
                return "<div class='equation-text-block st-required' contenteditable='true'></div>      \                                                                  \
                            <i title='Show Equations' class='glyphicon glyphicon-eye-close text-muted'                         \
                               style='                                                                  \
                                    position: absolute;                                                 \
                                    right: -81px;                                                       \
                                    top: 67px;                                                          \
                            '></i>                                                                      \                                                                       \
                        </div>";
            },

            onBlockRender: function() {
				var this_block = this;
				var $edit_button = $(this.el).find("#show_equations");
				this.$text_area = $(this.el).find(".equation-text-block");


				//Registers an equivalent of a "change" event listener to the contenteditable $text_area
				//Code from http://stackoverflow.com/questions/1391278/contenteditable-change-events
				this.$text_area.on('focus', function() {
					var $this = $(this);

					//Display the text entered by the user before it was rendered into math
					this_block.showRawText();

					//Store the current html to be checked for changes when done editing
					$this.data('before', $this.html());
				});

				//Events that indicate the contents of a contenteditable element may have changed
				this.$text_area.on('blur paste', function() {
					var $this = $(this);

					//if the user leaves the contenteditable blank they might forget it exists without the button reminding them
					if ($this.text().length > 0){
						$edit_button.hide();
					}

					//Check that the previously stored html is different after a paste/blur, otherwise we don't need to update the server data
					if ($this.data('before') !== $this.html()) {
						//Allows line breaks to be saved as <br> tags - solves issue in chrome where new lines of contenteditable elements are surrounded with div tags
						//http://stackoverflow.com/questions/6023307/dealing-with-line-breaks-on-contenteditable-div
						var html_with_br = $this.html().replace(/<div>/gi,'<br>').replace(/<\/div>/gi,'');
						$this.html(html_with_br);
					
						//update the current html associated with this element element
						$this.data('before', html_with_br);

						//Update the raw text entered by the user that will be sent to the server before mathjax modifies it
						this_block.toData();
					}
					//Render any delimited equations as mathjax
					this_block.addInlineMath($this);
				});

				//Check if data has already been loaded by sir trevor
				var preloaded_data = this.getBlockData();
				if (!jQuery.isEmptyObject(preloaded_data)){
					//add data to inputs and preview area using preloaded_data
					this.setBlock(preloaded_data);
					this_block.addInlineMath(this.$text_area);
				}
				this.$text_area.focus();
            },

			//Converts the text and equations back into a form that can be edited by the user
			showRawText: function(){
				//Remove all elements from the text_area so that there are no elements that were created by mathjax
				var savedText = this.getBlockData().text;
				if (savedText){
					this.$text_area.empty();
					//Show the raw text entered by the user before it was converted into mathjax, adding back in the line breaks
					this.$text_area.html(savedText.replace(/\n/gm,"<br>"));
				}
			},

			addInlineMath: function($elements){
				MathJax.Hub.queue.Push(["Typeset",MathJax.Hub,$elements.get()]);
			}
        })
    })(jQuery);
});