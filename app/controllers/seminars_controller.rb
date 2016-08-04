class SeminarsController < ApplicationController
  # uniche pagine da vedere senza essere loggati
  # index solitamente non si raggiunge perchè index è in home con insieme seminari e highlights
  skip_before_action :redirect_unsigned_user, only: [:index, :archive, :show, :totem]

  before_action :fix_place_and_room_params, only: [:create, :update]
  before_action :get_seminar_and_check_permission, only: [:edit, :update, :destroy, :mail_text, :submit_mail_text]

  # ics formato per ical
  def show
    @seminar = Seminar.find(params[:id])
    respond_to do |format|
      format.html { render layout: false }
      format.ics
    end  
  end

  # archivio quelli da ieri
  def archive
    @year = params[:year] ? params[:year].to_i : Date.today.year
    @seminars = Seminar.order('seminars.date DESC')
                       .where("YEAR(date) = ? and date < NOW()", @year)
                       .includes(:documents, :topics, repayment: :fund)
  end

  def choose_type
    @cycles  = current_user.cycles
    @serials = Serial.active
  end

  def new
    if params[:same_as]
      @seminar = Seminar.new(Seminar.find(params[:same_as]).attributes)
    else
      @seminar = Seminar.new(duration: 60,
                             place_id: Place.first.id, # WILL BE MOST COMMON PLACE FOR CURRENT_USER IN FUTIRE VERSION
                             committee: current_user.cn, 
                             date: Time.now + 1.day)
    end
    if params[:cycle_id]
      @cycle = Cycle.find(params[:cycle_id])
      @seminar.cycle_id = @cycle.id
      @seminar.committee = @cycle.committee
    elsif params[:serial_id]
      @serial = Serial.find(params[:serial_id])
      @seminar.serial_id = @serial.id
    end
  end

  def create
    @seminar = current_user.seminars.new(seminar_params)

    # nel caso sia rest (post)
    @seminar.cycle_id  = params[:cycle_id]  if params[:cycle_id]
    @seminar.serial_id = params[:serial_id] if params[:serial_id]

    if @seminar.save
      redirect_to mail_text_seminar_path(@seminar), notice: "Il seminario è stato creato correttamente."
    else
      render action: :new
    end
  end

  def edit
    @repayment = @seminar.repayment

    @serial    = @seminar.serial 
    @cycle     = @seminar.cycle
    @documents = @seminar.documents

    @document  = Document.new
  end

  def update
    if @seminar.update_attributes(seminar_params)
      redirect_to mail_text_seminar_path(@seminar), notice: "Il seminario è stato aggiornato."
    else
      # TO REFACTOR
      @repayment = @seminar.repayment
      @serial    = @seminar.serial 
      @cycle     = @seminar.cycle
      @documents = @seminar.documents
      @document  = Document.new
      render action: :edit
    end
  end

  def destroy
    if @seminar.destroy
      flash[:notice] = "Seminario eliminato"
    else
      flash[:error] = "Non è stato possibile eliminare il seminario"
    end
    redirect_to root_path
  end

  # Editing del mail avviso seminario 
  def mail_text
  end

  def submit_mail_text
    to      = params[:seminar_mail][:to].split(",")
    subject = params[:seminar_mail][:subject]
    text    = params[:seminar_mail][:text]

    if SeminarMailer.notify_seminar(@seminar, to, subject, text).deliver
      flash[:notice] = "La mail è stata inviata correttamente"
    else
      flash[:error] = "Errore nell'invio della mail"
    end
    redirect_to new_seminar_repayment_path(@seminar)
  end

  private 

  def get_seminar_and_check_permission
    @seminar = Seminar.find(params[:id])
    current_user.is_manager? or user_owns!(@seminar) 
  end

  def fix_place_and_room_params
    if params.delete(:place_id) == 0
      params[:room_id] = nil
    else
      params.delete(:room_description)
    end
  end

  def seminar_params
    p = [:date, :duration, :room_id, :room_description, :cycle_id, :serial_id, :speaker_title, :speaker, :committee, :title, :abstract, :file, :link, :link_text, :organization_id]
    p = p + [:user_id, :serial_id, :cycle_id] if current_user.is_admin?
    params[:seminar].permit(p)
  end

end
