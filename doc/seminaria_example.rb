ADMINS        = [ 'name.surname@example.it', 
                  'name.surname2@example.it', 
                ]

MANAGERS      = [ 'pippo.pluto@example.it', 
                  'marco.example@example.it' ]

MANAGERS_MAILS = ['dipmat.amministrazione@example.comf', 'o.oooo@example.it']

module Seminaria
  class Application < Rails::Application
    config.domain_name     = 'example.it'
    config.header_icon     = 'microphone'
    config.header_title    = 'Seminari'
    config.header_subtitle = 'Università di Bologna'

    # email from field
    config.default_from    = 'DipMat Seminari <pippo.pluto@unibo.it>'

    config.dm_unibo_common.update(
      login_method:        :log_and_create,
      message_footer:      %Q{Messaggio inviato da 'Gestione Seminari e Notizie Dipartimento di Matematica'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare testmail@example.comd},
      impersonate_admins:  ['name.surname@examplexample.com'],
      interceptor_mails:   ['name.surname2@examplexample.com'], 
    )
  end
end

