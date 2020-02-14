function roundToTwo(num) {    
  return (+(Math.round(num + "e+2")  + "e-2"));
};

function highlight_changes(what) {
  $(what).addClass("alert-warning");
}

$(function(){
  const irap = $("#payment_amount").data("irap");
  const irpef_italian = $("#payment_amount").data("irpef-italian");
  const irpef_foreign = $("#payment_amount").data("irpef-foreign");
  const adapt_net_italian_value = $("#payment_amount").data("adapt-net-italian-value");
  const adapt_net_foreign_value = $("#payment_amount").data("adapt-net-foreign-value");
  const adapt_gross_value = $("#payment_amount").data("adapt-gross-value");

  $("#payment_amount").visibility_from("#payment_bool");
  $("#refund_details").visibility_from("#refund_bool");

  function show_lordo_percipiente() {
    italy   = $('#repayment_italy_true').is(':checked');
    gross   = $("#repayment_gross_true").is(':checked'); 
    payment = $("#repayment_payment").val() || 0;

    console.log("changed repayment[italy]: italy=" + italy + " as: " + typeof(italy));

    gross_result = 0;
    net_result   = 0;
    irpef        = italy ? irpef_italian : irpef_foreign; 
    adapt_net    = italy ? adapt_net_italian_value : adapt_net_foreign_value;

    if (gross) {
      gross_result = payment;
      net_result   = payment * adapt_gross_value * (1 - irpef);  
    } else {
      net_result   = payment;
      gross_result = payment * adapt_net * (1 + irap);
    }

    $("#payment_summary").html("-> <strong>Lordo ente:</strong> " + roundToTwo(gross_result) + " &euro;<br/>" +
                               "-> <strong>Netto:</strong> "      + roundToTwo(net_result)   + " &euro;"); 
  };

  show_lordo_percipiente();

  $("#repayment_payment, .repayment_gross, input[name='repayment[italy]']").change(function() { 
    highlight_changes("#payment_summary");
    show_lordo_percipiente(); 
  });
});
