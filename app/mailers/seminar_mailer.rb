class SeminarMailer < ApplicationMailer
  def notify_seminar(seminar, to, subject, text)
    @seminar = seminar
    @to = to
    @text = text
    mail(
      to: to,
      reply_to: Rails.configuration.unibo_common.reply_to,
      subject: subject
    )
  end
end
