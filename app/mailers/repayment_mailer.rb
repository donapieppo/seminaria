# messo oscar in bcc perche' se in to insieme ad admin non riceve
class RepaymentMailer < ApplicationMailer
  #default from: 'DipMat Seminari <dipmat-supportoweb@unibo.it>'
  default from: 'DipMat Seminari <notifica.inviodlist.08218@unibo.it>'

  def notify_repayment_to_holder(repayment)
    @repayment = repayment
    @seminar   = @repayment.seminar
    mail(to:      [@repayment.holder.upn, "oscar.losurdo@unibo.it"], 
         cc:      [@seminar.user.upn, @seminar.organization.manager_mails].flatten,
         reply_to: 'dipmat-supportoweb@unibo.it', 
         subject: "Richiesta rimborso seminario di #{@seminar.speaker_with_title} su suoi fondi.")
  end

  def notify_fund(repayment)
    @repayment = repayment
    @seminar   = @repayment.seminar
    mail(to:      @seminar.organization.manager_mails,
         cc:      [@repayment.holder.upn, @seminar.user.upn, "oscar.losurdo@unibo.it"],
         reply_to: 'dipmat-supportoweb@unibo.it', 
         subject: "Approvazione rimborso seminario di #{@seminar.speaker_with_title}.")
  end
end


