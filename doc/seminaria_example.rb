CESIA_UPN = ["pietro.donatini@unibo.it"]

module Seminaria
  class Application < Rails::Application
    config.domain_name = "dm.unibo.it"

    config.html_title = "Seminari del Dipartimento di Matematica"
    config.html_description = "Gestione seminari e Notizie del Dipartimento di Matematia. Università di Bologna."
    config.header_title = "Seminari"
    config.header_subtitle = "del Dipartimento di Matematica"
    config.header_icon = "bullhorn"
    config.repayment_deadline = 14 # 8 days for working on repayment/refund before speaker arrival
    config.on_line_repayment_deadline_1 = 5  # 5 giorni prima della giunta
    config.on_line_repayment_deadline_2 = 10 # 10 fra la giunta e inizio del seminario

    config.default_from = "DipMat Seminari <notifica@example.it>"
    config.reply_to = "notifica@example.it"

    config.dm_unibo_common.update(
      login_method: :log_and_create,
      no_students: true,
      message_footer: %{Messaggio inviato da 'Gestione Seminari Dipartimento di Matematica'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare dipmat-supportoweb@unibo.it},
      impersonate_admins: ["name@unibo.it", "name2@unibo.it"],
      interceptor_mails: ["example@unibo.it"],
      main_impersonations: ["name@unibo.it"]
    )
  end
end
