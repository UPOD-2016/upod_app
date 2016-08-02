# resize-header.js.coffee

# Description:
# Resize the Select boxes in search forms to match the size of
# the highlighted (selected) text.
# RM
MOZ_TAB = 25 # size of arrow box in mozilla browser 2016
$ -> # This lines is equivalant to $(document).ready()
  $.fn.resizeselect = (settings) ->
    @each -> #step through each select element on page
      $(this).change(-> # create an anonymous method to change a class
        selected_text = $(this).find('option:selected').text()
        $temp_element = $('<span>').html(selected_text)
        $temp_element.appendTo 'body' # add span element to body
        width = $temp_element.width() # measure how large element is
        $temp_element.remove() # remove from page
        $(this).width width + MOZ_TAB # set width according to measurement
        return
      ).change() # call change method
      return
  $('select.resizeselect').resizeselect() # call add method
  return
return
# References:
# Source was originally taken from
# https://stackoverflow.com/questions/28308103/adjust-
# width-of-select-element-according-to-selected-options-width
# It was then modified to work on page load.
