class RepaymentsController < ApplicationController
  before_action :get_repayment_and_seminar_and_check_permission, only: [:show, :edit, :update, :notify, 
                                                                        :print_request, :print_decree, :print_letter, :print_proposal, :print_repayment, 
                                                                        :print_refund, :print_other, :print_regularity]
  before_action :get_seminar, only: [:new, :create]
  # su propri fondi
  before_action :get_repayment_and_check_permission, only: [:choose_fund, :update_fund]

  def index
    authorize current_organization, :manage?

    @year ||= (params[:year] || Date.today.year).to_i
    @repayments = Repayment.includes(seminar: :user, fund: [:category, :holder])
                           .order('seminars.date DESC')
                           .where("YEAR(seminars.date) = ?", @year)
                           .where("seminars.organization_id = ?", current_organization.id )
                           .references(:seminars)
  end

  def new
    if @seminar.repayment 
      redirect_to(seminar_path(@seminar), alert: 'Non è più possibile richiedere rimborso / compenso.') 
      return
    else
      @repayment = @seminar.build_repayment
      authorize @repayment
    end
  end

  # only the basic data
  def create
    if @seminar.repayment 
      redirect_to seminar_path(@seminar), alert: 'Non è più possibile richiedere rimborso / compenso.'
    else
      @repayment = @seminar.build_repayment(name:    params[:repayment][:name],
                                            surname: params[:repayment][:surname],
                                            email:   params[:repayment][:email]) 
      # speaker_arrival: @seminar.date, speaker_departure: @seminar.date)
      authorize @repayment
      if @repayment.save
        redirect_to repayment_path(@repayment)
      else
        redirect_to seminar_path(@seminar), alert: 'Non è stato possibile richiedere rimborso / compenso.'
      end
    end
  end

  # what = [reason, fund, compensation, speaker]
  def edit
    @funds = available_funds
    @what = params[:what] 
  end

  # has_one, e' un create/update
  def update
    @what = params[:what] # hidden 
    get_and_validate_holder

    if @what == 'compensation'
      fix_payment_params
      # fix_refund_params
    end

    @repayment.assign_attributes(repayment_params)

    if @holder
      @repayment.holder_id = @holder.id
    end

    if @repayment.save
      add_cv
      redirect_to repayment_path(@repayment), message: "La richiesta è stata salvata correttamente."
    else
      @funds = available_funds
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  # MODULISTICA 

  def print_request
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('richiesta_docente')}\"" }
    end
  end

  def print_letter
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('lettera_di_incarico')}\"" }
    end
  end

  def print_decree
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('decreto')}\"" }
    end
  end

  def print_proposal
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('proposta_di_compenso_o_rimborso')}\"" }
    end
  end

  def print_repayment
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('dati_anagrafici_e_modalita_pagamento')}\"" }
    end
  end

  def print_refund
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('nota_spese_trasferta')}\"" }
    end
  end

  def print_other
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('altri_incarichi_trasferta')}\"" }
    end
  end

  def print_regularity
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"#{@repayment.letter_filename_docx('regolare_esecuzione')}\"" }
    end
  end

  # Utilizzato da user se non possiede i fondi. Invia mail al gestore dei fondi 
  # che ha scelto. Una volta notificato non può più essere cambiato da utente.
  def notify
    if user_too_late_for_repayment?(@seminar)
      redirect_to seminar_path(@seminar), alert: 'Non è più possibile richiedere rimborso / compenso.'
    else
      @repayment.update_attribute(:notified, true)
      if ! @repayment.fund
        # notify who has to choose the fund
        RepaymentMailer.notify_repayment_to_holder(@repayment).deliver
        flash[:notice] = "La richiesta di rimborso è stata inviata a #{@repayment.holder}."
      else
        RepaymentMailer.notify_fund(@repayment).deliver
        flash[:notice] = "La richiesta di rimborso è stata inviata all'amministrazione."
      end
    end
  end

  def choose_fund
    @funds = available_funds
    @too_late_for_repayment = user_too_late_for_repayment?(@repayment.seminar)
  end

  def update_fund
    only_manager_can_choose_late!

    @fund = Fund.find(params[:repayment][:fund_id])

    # amministrazione può cambiare fondo e proprietario
    if @fund.holder_id != @repayment.holder_id
      if user_is_manager?
        @repayment.update_attribute(:holder_id, @fund.holder_id) 
      else
        raise "NO PERMISSION"
      end
    end

    @repayment.update_attribute(:fund_id, @fund.id)

    RepaymentMailer.notify_fund(@repayment).deliver unless (policy(@repayment.seminar).update?)
    redirect_to root_path, notice: "È stato selezionato il fondo #{@fund.to_s}."
  end

  private

  def repayment_params
    p = [:name, :surname, :email, :address, :postalcode, :city, :italy, :country, :birth_date, :birth_place, :birth_country, :affiliation,
         :payment, :gross, :position_id, :role, :refund, 
         :reason, :activity_details, :scientific_interests, 
         :speaker_arrival, :speaker_departure, :expected_refund, :taxid, 
         :iban, :swift, :aba, :bank_name, :bank_address]
    p = p + [:bond_number, :bond_year] if policy(@repayment).update_bond?
    p = p + [:fund_id] if policy(@repayment).update_fund?
    params[:repayment].permit(p)
  end

  def get_seminar
    @seminar = Seminar.find(params[:seminar_id])
  end

  def get_repayment_and_seminar_and_check_permission
    @repayment = Repayment.find(params[:id])
    @seminar = @repayment.seminar
    authorize @repayment
  end

  def get_repayment_and_check_permission
    @repayment = Repayment.find(params[:id])
    begin
      authorize @repayment
    rescue Pundit::NotAuthorizedError
      redirect_to seminars_path, alert: "Solo il titolare può modificare il fondo."
    end
  end

  # FIXME in model
  def get_and_validate_holder
    anagrafica_unica_holder = params[:repayment].delete(:holder_id)
    @holder = anagrafica_unica_holder.blank? ? nil : User.update_from_anagrafica_unica(anagrafica_unica_holder) 
  end

  def available_funds
    user_is_manager? ? Fund.active.includes(:holder, :category).order('users.surname, users.name').references(:user) : current_user.funds.active
  end

  def fix_payment_params
    # params[:payment_bool] e' "0" o "1"
    # se non selezionato sovrascriviamo con nil i vecchi valori
    if params[:payment_bool] == "0"
      params[:repayment][:payment] = params[:repayment][:gross] = nil
    else 
      # virgola in cifra => punto
      params[:repayment][:payment].gsub!(',', '.')
    end
  end

  def fix_refund_params
    # non piu'
    # params[:repayment][:refund] e' "0" o "1"
    #if params[:repayment][:refund] == "0" 
    #  params[:repayment][:expected_refund] = params[:repayment][:speaker_arrival] = params[:repayment][:speaker_departure] = nil
    #end
  end

  def add_cv
    if params[:repayment][:cv]
      document = @repayment.curricula_vitae.create!(attach: params[:repayment][:cv], description: "CV", user_id: current_user.id)
    end
  end

  def only_manager_can_choose_late!
    if user_too_late_for_repayment?(@repayment.seminar)
      raise "TOO LATE"
    end
  end
end

