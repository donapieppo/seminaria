// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

import * as bootstrap from "bootstrap"

import Rails from "@rails/ujs"
Rails.start()

window.display_unless = function (txt, what, condition_input) {
  what.style.display = (condition_input.value == txt) ? 'none' : 'block';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.value);
    what.style.display = (condition_input.value === txt) ? 'none' : 'block';
  });
}

window.display_if = function (txt, what, condition_input) {
  what.style.display = (condition_input.value == txt) ? 'block' : 'none';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.value);
    what.style.display = (condition_input.value === txt) ? 'block' : 'none';
  });
}

window.display_if_checked = function (what, condition_input) {
  what.style.display = (condition_input.checked) ? 'block' : 'none';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.checked);
    what.style.display = (condition_input.checked) ? 'block' : 'none';
  });
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelectorAll(".actions-button").forEach( (i) => {
    i.addEventListener("click", function() {
      y = i.nextElementSibling;
      if (y.style.display === "none") { y.style.display = "block"; } else { y.style.display = "none"; }
    });
  });
});

