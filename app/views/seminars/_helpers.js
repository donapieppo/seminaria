function toggle_div (boolean_div, first_div, second_div, with_listener = true) {
  console.log(`toggle_div on ${boolean_div} with_listener=${with_listener}`);
  check_input = document.querySelector(boolean_div);

  if (first_div && document.querySelector(first_div)) {
    document.querySelector(first_div).style.display  = check_input.checked ? 'block' : 'none';
  }
  if (second_div && document.querySelector(second_div)) {
    document.querySelector(second_div).style.display = check_input.checked ? 'none' : 'block';
  }

  if (check_input && with_listener) {
    console.log("addEventListener");
    check_input.addEventListener('change', function() { 
      toggle_div(boolean_div, first_div, second_div, false);
    });
  }
};

toggle_div("#seminar_on_line", "#on_line_seminar", null, true);
toggle_div("#seminar_in_presence", "#in_presence_seminar", null, true);
toggle_div("#seminar_zoom_meeting_create", "#zoom_auto_div", "#manual_seminar_div", true);

function description_field() {
  console.log(`description_field`);
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
});

