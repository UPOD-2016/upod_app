// Resize the Select boxes in search forms to match the size of the highlighted
// (selected) text.
// Source was originally taken from
// https://stackoverflow.com/questions/28308103/adjust-width-of-select-element-according-to-selected-options-width
// It was then modified to work on page load and with turbolinks. Redundant fn calls were taken out.
// RM

$(function() {
  $.fn.resizeselect = function(settings) {
    return this.each(function() {
      $(this).change(function() {
        var $this = $(this);
        var selected_text = $this.find("option:selected").text();
        var $temp_element = $("<span>").html(selected_text);

        //adds a temporary element which contains the selected
        //text to the body of the html document. It then measures
        //the width of this new element and destroys it.
        $temp_element.appendTo('body');
          var width = $test.width();
        $temp_element.remove();

        $this.width(width);
      }).change();
    });
  };
});

//make sure this works with turbo links by calling the function
//each time the page is "loaded" by turbolinks
$(document).on("turbolinks:load", function(){
  return $("select.resizeselect").resizeselect();
})
