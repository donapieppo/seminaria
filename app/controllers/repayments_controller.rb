class RepaymentsController < ApplicationController
  before_action :user_is_manager!, only: [:index]

  # richiesta su proprio seminario
  before_action :get_seminar_and_check_seminar_permission, only: [:new, :create, :update] # edit - update aliases di new - create
  # propria richiesta o su propri fondi
  before_action :get_repayment_and_check_permission,       only: [:show, :notify, :print_decree, :print_letter, :print_proposal]
  # su propri fondi
  before_action :get_repayment_and_check_fund_permission,  only: [:choose_fund, :fund]
  before_action :get_and_validate_holder,                  only: [:create, :update]

  def index
    @year ||= (params[:year] || Date.today.year).to_i
    @repayments = Repayment.includes(:seminar, :fund)
                           .order('seminars.date DESC')
                           .where("YEAR(seminars.date) = ?", @year)
                           .references(:seminars)
  end

  # has_one, e' un new/edit
  def new
    unless @too_late_for_repayment = user_too_late_for_repayment?(@seminar)
      @repayment = @seminar.repayment || @seminar.build_repayment(italy: true, birth_country: "Italia", speaker_arrival: @seminar.date, speaker_departure: @seminar.date)
    end
  end

  # has_one, e' un create/update
  def create
    fix_payment
    fix_refund

    params[:repayment][:country] = 'Italia' if params[:repayment][:italy] == '1'

    if @repayment = @seminar.repayment # edit. FIXME pensare se con too late non puo' modificare
      @repayment.assign_attributes(repayment_params)
    else                               # new
      if @too_late_for_repayment = user_too_late_for_repayment?(@seminar)
        redirect_to edit_seminar_path(seminar), alert: "È troppo tardi per richiedere rimborso e/o compenso."
        return
      end
      @repayment = @seminar.build_repayment(repayment_params)
    end

    if missing_cv?
      @repayment.errors.add(:cv, 'Si prega di inserire il curriculum vitae.')
      render :new and return
    end

    @repayment.holder_id = @holder.id

    if (user_is_manager? or ! @repayment.notified) and @repayment.save
      add_cv
      redirect_to repayment_path(@repayment), message: "La richiesta è stata salvata correttamente."
    else
      render :new
    end
  end

  alias update create

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
  # che ha scelto. Una volta notificato non puo' piu' essere cambiato da utente
  def notify
    @repayment.update_attribute(:notified, true)
    if @repayment.fund_id.nil?
      RepaymentMailer.notify_repayment_to_holder(@repayment).deliver
      flash[:notice] = "La richiesta di rimborso è stata inviata a #{@repayment.holder}."
    end
    redirect_to root_path
  end

  def choose_fund
    @funds = available_funds
    @too_late_for_repayment = user_too_late_for_repayment?(@repayment.seminar)
  end

  def fund
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
    p = [:name, :surname, :email, :address, :postalcode, :city, :italy, :country, :birth_date, :birth_place, :birth_country, :payment, :gross, :position_id, :role, :refund, :affiliation, :reason, :speaker_arrival, :speaker_departure, :expected_refund]
    p = p + [:bond_number, :bond_year] if current_user.is_admin?
    params[:repayment].permit(p)
  end

  def get_seminar_and_check_seminar_permission
    @seminar = Seminar.find(params[:seminar_id])
    user_is_manager? or user_owns!(@seminar) 
  end

  def get_repayment_and_check_permission
    @repayment = Repayment.find(params[:id])
    user_is_manager? or user_is_holder?(@repayment.seminar) or user_owns!(@repayment.seminar)
  end

  def get_repayment_and_check_fund_permission
    @repayment = Repayment.find(params[:id])
    user_is_manager? or (@repayment.holder_id == current_user.id) or raise "No access"
  end

  # FIXME in model
  def get_and_validate_holder
    anagrafica_unica_holder = params[:repayment].delete(:holder_id)
    @holder = User.update_from_anagrafica_unica(anagrafica_unica_holder)
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

  def missing_cv?
    # @repayment.payment and @repayment.documents.empty? and ! params[:repayment][:cv]
    @repayment.documents.empty? and ! params[:repayment][:cv]
  end

  def add_cv
    if params[:repayment][:cv]
      document = Document.create!(attach: params[:repayment][:cv], description: "CV", user_id: current_user.id)
      logger.info document.inspect
      @repayment.documents << document
    else
      logger.info "no repayment, no cv"
    end
  end

  def only_manager_can_choose_late!
    if user_too_late_for_repayment?(@repayment.seminar)
      raise "TOO LATE"
    end
  end
end

