function description_field() {
  $("#seminar_place_id option:selected").each(function() {
    if ($(this).val() == "2") {
      $(".seminar_place_description").show('slow');
    } else {
      $(".seminar_place_description").hide('fast');
    }
  });
}
  
$(document).ready(function() {
  description_field();

  $("#seminar_place_id").change(function() {
    description_field();
  });

  $(".actions-button").click(function() { 
    $(this).next(".actions-popup").toggle();
  });
});

