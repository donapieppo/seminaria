class RepaymentsController < ApplicationController
  # propria richiesta o su propri fondi
  before_action :get_repayment_and_seminar_and_check_permission, only: [:show, :edit, :update, :notify, :print_decree, :print_letter, :print_proposal]
  # su propri fondi
  before_action :get_repayment_and_check_permission, only: [:choose_fund, :update_fund]
  before_action :get_and_validate_holder,                 only: [:update]

  def index
    @year ||= (params[:year] || Date.today.year).to_i
    @repayments = Repayment.includes(seminar: :user, fund: [:category, :holder])
                           .order('seminars.date DESC')
                           .where("YEAR(seminars.date) = ?", @year)
                           .where("seminars.organization_id = ?", current_organization.id )
                           .references(:seminars)
    # FIXME: how to pass organization to pundit index?
    authorize current_organization, :manage?
  end

  def new
    @seminar = Seminar.find(params[:seminar_id])

    if user_too_late_for_repayment?(@seminar)
      redirect_to seminar_path(@seminar), alert: 'Non è più possibile richiedere rimborso / compenso.'
    else
      @repayment = @seminar.repayment || @seminar.build_repayment(speaker_arrival: @seminar.date, speaker_departure: @seminar.date)
      authorize @repayment
      if @repayment.save
        render action: :show
      else
        redirect_to seminar_path(@seminar), alert: 'Non è più possibile richiedere rimborso / compenso.'
      end
    end
  end

  # what = [reason, fund, compensation, speaker]
  def edit
    if user_too_late_for_repayment?(@seminar)
      redirect_to seminar_path(@seminar), alert: 'Non è più possibile agire sul rimborso / compenso.'
      return
    else
      @funds = available_funds
      @what = params[:what] 
      render layout: false if modal_page
    end  
  end

  # has_one, e' un create/update
  def update
    @what = params[:what] # hidden 

    if @what == 'compensation'
      fix_payment
      fix_refund
    end

    if @repayment = @seminar.repayment # edit. FIXME pensare se con too late non puo' modificare
      @repayment.assign_attributes(repayment_params)
    else                               # new
      if @too_late_for_repayment = user_too_late_for_repayment?(@seminar)
        redirect_to edit_seminar_path(seminar), alert: "È troppo tardi per richiedere rimborso e/o compenso."
        return
      end
      @repayment = @seminar.build_repayment(repayment_params)
    end

    if @holder
      @repayment.holder_id = @holder.id
    end

    if (user_is_manager? or ! @repayment.notified) and @repayment.save
      add_cv
      redirect_to repayment_path(@repayment), message: "La richiesta è stata salvata correttamente."
    else
      @funds = available_funds
      render :edit
    end
  end

  def show
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

  # Utilizzato da user se non possiede i fondi. Invia mail al gestore dei fondi 
  # che ha scelto. Una volta notificato non può più essere cambiato da utente.
  def notify
    @repayment.update_attribute(:notified, true)
    if ! @repayment.fund
      RepaymentMailer.notify_repayment_to_holder(@repayment).deliver
      flash[:notice] = "La richiesta di rimborso è stata inviata a #{@repayment.holder}."
    else
      RepaymentMailer.notify_fund(@repayment).deliver
      flash[:notice] = "La richiesta di rimborso è stata inviata all'amministrazione."
    end
    redirect_to root_path
  end

  def choose_fund
    @funds = available_funds
    @too_late_for_repayment = user_too_late_for_repayment?(@repayment.seminar)
  end

  def update_fund
    only_manager_can_choose_late!

    @fund = Fund.find(params[:repayment][:fund_id])
    (@fund.holder_id == current_user.id or user_is_manager?) or raise "NO PERMISSION"

    # amministrazione può cambiare fondo e proprietario
    if @fund.holder_id != @repayment.holder_id
      if user_is_manager?
        @repayment.update_attribute(:holder_id, @fund.holder_id) 
      else
        raise "NO PERMISSION"
      end
    end

    @repayment.update_attribute(:fund_id, @fund.id)
    RepaymentMailer.notify_fund(@repayment).deliver unless user_is_manager?
    # se proprietario e richiedente coincidono e' come fare notify
    if user_owns?(@repayment.seminar) 
      @repayment.update_attribute(:notified, true)
    end
    redirect_to root_path, notice: "È stato selezionato il fondo #{@fund.to_s}."
  end

  private

  def repayment_params
    p = [:name, :surname, :email, :address, :postalcode, :city, :italy, :country, :birth_date, :birth_place, :birth_country, :affiliation,
         :payment, :gross, :position_id, :role, :refund, :reason, :speaker_arrival, :speaker_departure, :expected_refund]
    p = p + [:bond_number, :bond_year] if user_is_manager?
    p = p + [:fund_id] if policy(@repayment).update_fund?
    params[:repayment].permit(p)
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

  def fix_payment
    # params[:payment_bool] e' nil o on
    if (! params[:payment_bool]) or (params[:repayment][:payment].blank?)
      # non delete perche' deve sovrascrivere 
      params[:repayment][:payment] = params[:repayment][:gross] = nil
    else 
      # virgola in cifra => punto
      params[:repayment][:payment].gsub!(',', '.')
    end
  end
  
  def fix_refund
    # params[:repayment][:refund] e' "0" o "1"
    if params[:repayment][:refund] == "0" 
      params[:repayment][:expected_refund] = params[:repayment][:speaker_arrival] = params[:repayment][:speaker_departure] = nil
    end
  end

  def cv_params
    params[:repayment][:cv].permit(:description, :attach)
  end

  def add_cv
    if params[:repayment][:cv]
      document = Document.create!(attach: params[:repayment][:cv], description: "CV", user_id: current_user.id)
      logger.info document.inspect
      @repayment.documents << document
    end
  end

  def only_manager_can_choose_late!
    if user_too_late_for_repayment?(@repayment.seminar)
      raise "TOO LATE"
    end
  end
end

