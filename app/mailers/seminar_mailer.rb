class SeminarMailer < ActionMailer::Base
  default from: Rails.configuration.default_from

  def notify_seminar(seminar, to, subject, text)
    @seminar = seminar
    @to      = to
    @text    = text
    mail(to:       to,
         reply_to: Rails.configuration.reply_to, 
         subject:  subject)
  end
end


