import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "place", "online" ]
  static values = { inpresence: Boolean, online: Boolean }

  connect() {
    console.log("in where");
    this.placeTarget.style.display = this.inpresenceValue ? 'block' : 'none';
    this.onlineTarget.style.display = this.onlineValue ? 'block' : 'none';
  }

  show_place(el) {
    console.log("change presence");
    this.placeTarget.style.display = el.target.checked ? 'block' : 'none';
  }

  show_online(el) {
    console.log("change online");
    this.onlineTarget.style.display = el.target.checked ? 'block' : 'none';
  }
}
