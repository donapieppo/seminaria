import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "positionInput" ];

  connect() {
    const ALTRO_ID = 8;
    this.positionInputTarget.addEventListener("change", function(e) { 
      if (e.target.value == ALTRO_ID) {
        alert("Ricordarsi di completare il campo successivo fornendo la descrizione della qualifica e/o attività del relatore.");
      }
    });
  }
}

