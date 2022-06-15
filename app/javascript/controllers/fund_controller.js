import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "holder", "fund" ];
  static values = { manager: Boolean };

  connect() {
    console.log("connected fund controller");
    var fundDiv = this.fundTarget;
    var manager = this.managerValue;
    console.log(fundDiv)
    console.log(manager)
    if (! manager) {
      this.holderTarget.addEventListener("change", function(e) { 
        if (fundDiv) {
          fundDiv.style.display = 'none';
        }
      });
    }
  }
}

