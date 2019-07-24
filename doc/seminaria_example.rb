CESIA_UPN = ['administrator@example.com']

module Seminaria
  class Application < Rails::Application
    config.domain_name        = 'example.it'

    config.organizations_urls = { 'math'   => 1,
                                  'chmica' => 2 }
    config.header_icon        = 'microphone'
    config.header_title       = 'Seminari'
    config.header_subtitle    = 'Università di Bologna'
    config.repayment_deadline = 14 # 8 days for working on repayment/refund before speaker arrival

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

