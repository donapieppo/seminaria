function description_field() {
  $("#seminar_place_id option:selected").each(function() {
    if ($(this).val() == "2") {
      $(".seminar_place_description").show('slow');
    } else {
      $(".seminar_place_description").hide('fast');
    }
  });
}
  
function roundToTwo(num) {    
  return (+(Math.round(num + "e+2")  + "e-2"));
};

$(document).ready(function() {
  description_field();

  $("#seminar_place_id").change(function() {
    description_field();
  });

  $(".actions-button").click(function() { 
    $(this).next(".actions-popup").toggle();
  });

  // visible if checked
  $.fn.visibility_from = function (bool_check){
    var visible_element = this;
    visible_element.toggle($(bool_check).is(':checked'));
    $(bool_check).change(function(){
      visible_element.toggle($(bool_check).is(':checked'));
    });
    return visible_element;
  }

});

