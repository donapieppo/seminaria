import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "in_presence", "in_presence_details", "place_selector", "place_description", "on_line", "on_line_details" ];

  place_description_field() {
    var place_decription_to_show = (this.place_selectorTarget.selectedIndex === 1);
    this.place_descriptionTarget.style.display = place_decription_to_show ? 'block' : 'none';
  }

  connect() {
    console.log("connect where");
    toggle_div(this.in_presenceTarget, this.in_presence_detailsTarget, null, true);
    toggle_div(this.on_lineTarget, this.on_line_detailsTarget, null, true);

    this.place_description_field();
    this.place_selectorTarget.addEventListener('change', () => {
      this.place_description_field();
    });
  }
}
