import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "paymentBool", "paymentDetails", "italyBool", "paymentAmount", "grossBool", "paymentSummary" ];
  static values = {
    irap: String,
    irpefItalian: String,
    irpefForeign: String,
    adaptNetItalian: String,
    adaptNetForeign: String,
    adaptGross: String
  };

  show_lordo_percipiente() {
    var italy   = this.italyBoolTarget.checked;
    var gross   = this.grossBoolTarget.checked;
    var payment = this.paymentAmountTarget.value || 0;
    console.log(`payment: ${payment} italy: ${italy} gross: ${gross}`);

    var gross_result = 0;
    var net_result   = 0;
    var irpef        = italy ? this.irpef_italian : this.irpef_foreign; 
    var adapt_net    = italy ? this.adapt_net_italian_value : this.adapt_net_foreign_value;
    console.log(`gross_result: ${gross_result} net_result: ${net_result} irpef: ${irpef} adapt_net: ${adapt_net}`);

    if (gross) {
      net_result   = payment * this.adapt_gross_value * (1 - irpef);  
      gross_result = payment;
      console.log(`gross payment: net_result: ${net_result} gross_result: ${gross_result}`)
    } else {
      console.log(`correct 1.0 + this.irap: 1.0 + ${this.irap}: ${1.0 + this.irap}`);
      net_result   = payment;
      gross_result = payment * adapt_net * (1.0 + this.irap);
      console.log(`net payment: net_result: ${net_result} gross_result: ${gross_result}`)
    }

    this.paymentSummaryTarget.innerHTML = "-> <strong>Lordo ente:</strong> " + this.roundToTwo(gross_result) + " &euro;<br/>" +
                                          "-> <strong>Netto:</strong> " + this.roundToTwo(net_result) + " &euro;"; 
  }

  roundToTwo(num) {
    return (+(Math.round(num + "e+2")  + "e-2"));
  }

  highlight_changes() {
    this.paymentSummaryTarget.classList.add("alert-warning");
  }

  connect() {
    this.irap                    = parseFloat(this.irapValue);
    this.irpef_italian           = parseFloat(this.irpefItalianValue);
    this.irpef_foreign           = parseFloat(this.irpefForeignValue);
    this.adapt_net_italian_value = parseFloat(this.adaptNetItalianValue);
    this.adapt_net_foreign_value = parseFloat(this.adaptNetForeignValue);
    this.adapt_gross_value       = parseFloat(this.adaptGrossValue);
    console.log(`irap: ${this.irap} irpef_italian: ${this.irpef_italian} irpef_foreign: ${this.irpef_foreign} adapt_net_italian_value: ${this.adapt_net_italian_value} adapt_net_foreign_value: ${this.adapt_net_foreign_value} adapt_gross_value: ${this.adapt_gross_value}`)

    display_if_checked(this.paymentDetailsTarget, this.paymentBoolTarget);

    this.show_lordo_percipiente();
    this.paymentDetailsTarget.addEventListener('change', (e) => { 
      this.highlight_changes();
      this.show_lordo_percipiente(); 
    });
  }
}

