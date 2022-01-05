// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function() {
  // visible if checked
  $.fn.visibility_from = function (bool_check){
    var visible_element = this;
    visible_element.toggle($(bool_check).is(':checked'));
    $(bool_check).change(function(){
      visible_element.toggle($(bool_check).is(':checked'));
    });
    return visible_element;
  }
  $(".actions-button").click(function() {
    $(this).next(".actions-popup").toggle();
  });
});


import * as bootstrap from "bootstrap"
