CESIA_UPN = ['administrator@example.com']

module Seminaria
  class Application < Rails::Application
    config.domain_name        = 'example.it'

    # exammple: with https://example.it/math your session is on Organization.find(1)
    config.organizations_urls = { 'math'      => 1,
                                  'chemistry' => 2,
                                  'disi'      => 3 }

    config.header_icon        = 'microphone'
    config.header_title       = 'Seminari'
    config.header_subtitle    = 'Università di Bologna'
    config.repayment_deadline = 14 # 8 days for working on repayment/refund before speaker arrival
    config.on_line_repayment_deadline_1 = 5  # 5 giorni prima della giunta
    config.on_line_repayment_deadline_2 = 15 # 15 giorni prima del seminario

    # email from field
    config.default_from    = 'DipMat Seminari <pippo.pluto@example.com>'
    config.reply_to        = 'support@example.com'

    config.dm_unibo_common.update(
      login_method:        :log_and_create,
      message_footer:      %Q{Messaggio inviato da 'Gestione Seminari Dipartimento di Matematica'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare testmail@example.comd},
      impersonate_admins:  ['administrator@example.com'],
      interceptor_mails:   ['name.surname2@examplexample.com'], 
    )
  end
end

