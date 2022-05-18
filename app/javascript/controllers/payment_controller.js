import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "paymentBool", "paymentAmount" ];
  static values = {
    irap: String,
    irpef_italian: String,
    irpef_foreign: String,
    adapt_net_italian: String,
    adapt_net_foreign: String,
    adapt_gross: String
  };

  show_lordo_percipiente() {
    var italy   = document.getElementById("repayment_italy_true").checked;
    var gross   = document.getElementById("repayment_gross_true").checked; 
    var payment = document.getElementById("repayment_payment").value || 0;
    console.log("payment: " + payment);

    gross_result = 0;
    net_result   = 0;
    irpef        = italy ? irpef_italian : irpef_foreign; 
    adapt_net    = italy ? adapt_net_italian_value : adapt_net_foreign_value;

    if (gross) {
      gross_result = payment;
      net_result   = payment * adapt_gross_value * (1 - irpef);  
    } else {
      console.log(payment);
      console.log(adapt_net);
      console.log(irap);
      console.log(1.0 + irap);
      net_result   = payment;
      gross_result = payment * adapt_net * (1.0 + irap);
      console.log(gross_result);
    }

    document.getElementById("payment_summary").innerHTML = "-> <strong>Lordo ente:</strong> " + roundToTwo(gross_result) + " &euro;<br/>" +
    "-> <strong>Netto:</strong> "      + roundToTwo(net_result)   + " &euro;"; 
  }

  roundToTwo(num) {
    return (+(Math.round(num + "e+2")  + "e-2"));
  }

  highlight_changes(what) {
    what.classList.add("alert-warning");
  }

  connect() {
    const irap                    = parseFloat(this.irapValue);
    const irpef_italian           = parseFloat(this.irpefItalianValue);
    const irpef_foreign           = parseFloat(this.irpefForeignValue);
    const adapt_net_italian_value = parseFloat(this.adaptNetItalianValue);
    const adapt_net_foreign_value = parseFloat(this.adaptNetForeignValue);
    const adapt_gross_value       = parseFloat(this.adaptGrossValue);

    display_if_checked(this.paymentAmountTarget, this.paymentBoolTarget);

    this.show_lordo_percipiente();
      document.querySelectorAll("#repayment_payment, .repayment_gross, input[name='repayment[italy]']").forEach( (i) => {
      i.addEventListener('change', (e) => { 
        highlight_changes(document.getElementById("payment_summary"));
         show_lordo_percipiente(); 
      });
    });
  }
}

