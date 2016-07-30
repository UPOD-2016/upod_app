# resize-header.js.coffee

# Description:
# Resize the Select boxes in search forms to match the size of the highlighted (selected) text.

# References:
# Source was originally taken from
# https://stackoverflow.com/questions/28308103/adjust-width-of-select-element-according-to-selected-options-width
# It was then modified to work on page load and with turbolinks. Redundant fn calls were taken out.
# RM

$ -> # This lines is equivalant to $(document).ready()
  $.fn.resizeselect = (settings) -> # create an anonymous method to add to a class
    @each -> #step through each select element on page
      $(this).change(-> # create an anonymous method to change a class
        $this = $(this) #get select class
        selected_text = $this.find('option:selected').text() # get selected text
        $temp_element = $('<span>').html(selected_text) #create a span element with text
        $temp_element.appendTo 'body' # add span element to body
        width = $temp_element.width() # measure how large element is on current page size
        $temp_element.remove() # remove from page
        $this.width width # set width according to measurement above
        return
      ).change() # call change method
      return
  $('select.resizeselect').resizeselect() # call add method
  return
return  
