import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "refundBool", "refundDetails" ];

  connect() {
    display_if_checked(this.refundDetailsTarget, this.refundBoolTarget);
  }
}

