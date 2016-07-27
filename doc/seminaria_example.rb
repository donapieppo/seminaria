ADMINS        = [ 'name.surname@example.it', 
                  'pietro.donatini@unibo.it', 
                ]

MANAGERS      = [ 'claudia.gamberini@unibo.it',
                  'oscar.losurdo@unibo.it',
                  'angela.finelli@unibo.it',
                  'anna.macagnino@unibo.it',
                  'marco.baccolini@unibo.it' ]

MANAGERS_MAILS = ['dipmat.amministrazione@unibo.it', 'oscar.losurdo@unibo.it']

module Seminars
  class Application < Rails::Application
    config.domain_name     = 'example.it'
    config.header_icon     = 'microphone'
    config.header_title    = 'Seminari'
    config.header_subtitle = 'Università di Bologna'

    config.dm_unibo_common.update(
      login_method:        :log_and_create,
      message_footer:      %Q{Messaggio inviato da 'Gestione Seminari e Notizie Dipartimento di Matematica'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare dipmat-supportoweb@unibo.it},
      impersonate_admins:  ['pietro.donatini@unibo.it'],
      interceptor_mails:   ['donatini@dm.unibo.it'], 
    )
  end
end

Paperclip.options[:content_type_mappings] = { pdf: [ "application/pdf", "binary/octet-stream" ] }

