# resize-header.js.coffee
# Description:
# Resize the Select boxes in search forms to match the size of the highlighted
# (selected) text.
# References:
# Source was originally taken from
# https://stackoverflow.com/questions/28308103/adjust-width-of-select-element-according-to-selected-options-width
# It was then modified to work on page load and with turbolinks. Redundant fn calls were taken out.
# RM

$ ->
  $.fn.resizeselect = (settings) ->
    @each ->
      $(this).change(->
        $this = $(this)
        selected_text = $this.find('option:selected').text()
        $temp_element = $('<span>').html(selected_text)
        # add to body, get width, and remove
        $temp_element.appendTo 'body'
        width = $temp_element.width()
        $temp_element.remove()
        $this.width width
        return
      ).change()
      return
  $('select.resizeselect').resizeselect()
  return


$(document).on 'turbolinks:load', ->
  $('select.resizeselect').resizeselect()
