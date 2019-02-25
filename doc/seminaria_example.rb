if Rails.configuration.dm_unibo_common[:smtp_password] 
  ActionMailer::Base.smtp_settings = {
    address:        'example.it',
    port:           587,
    user_name:      'notifica.invio@example.it',
    password:       Rails.configuration.dm_unibo_common[:smtp_password],
    authentication: :login,
    enable_starttls_auto: true
  }
end

CESIA_UPN = ['admin.name@example.com']

module Seminaria
  class Application < Rails::Application
    config.domain_name     = 'example.it'
    config.header_icon     = 'microphone'
    config.header_title    = 'Seminari'
    config.header_subtitle = 'Università di Bologna'

    # email from field
    config.default_from    = 'DipMat Seminari <pippo.pluto@example.com>'
    config.reply_to        = 'support@example.com'

    config.dm_unibo_common.update(
      login_method:        :log_and_create,
      message_footer:      %Q{Messaggio inviato da 'Gestione Seminari Dipartimento di Matematica'.\nNon rispondere a questo messaggio.\nPer problemi tecnici contattare testmail@example.comd},
      impersonate_admins:  ['name.surname@examplexample.com'],
      interceptor_mails:   ['name.surname2@examplexample.com'], 
    )
  end
end

