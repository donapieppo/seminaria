class HighlightMailer < ActionMailer::Base
  default from: Rails.configuration.default_from

  def notify_highlight_to_commissioners(highlight)
    @highlight = highlight
    mail(to:       User.commissioners_mails + User.publishers_mails,
         reply_to: Rails.configuration.reply_to, 
         subject:  'Richiesta valutazione nuova notizia')
  end
end
