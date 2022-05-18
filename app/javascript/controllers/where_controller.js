import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "place", "placedescription", "online", "manual", "zoom" ];
  static values = { inpresence: Boolean, online: Boolean, zoom: Boolean };

  connect() {
    console.log("connect where");
    this.placeTarget.style.display = this.inpresenceValue ? 'block' : 'none';
    this.onlineTarget.style.display = this.onlineValue ? 'block' : 'none';
    this.zoomTarget.style.display = this.zoomValue ? 'block' : 'none';
    this.manualTarget.style.display = this.zoomValue ? 'none' : 'block';
  }

  show_place(el) {
    console.log("change presence");
    this.placeTarget.style.display = el.target.checked ? 'block' : 'none';
  }

  show_online(el) {
    console.log("change online");
    this.onlineTarget.style.display = el.target.checked ? 'block' : 'none';
  }

  show_zoom(el) {
    console.log("change zoom");
    this.zoomTarget.style.display = el.target.checked ? 'block' : 'none';
    this.manualTarget.style.display = el.target.checked ? 'none' : 'block';
  }

  show_place_description(el) {
    console.log("change place");
  }
}
