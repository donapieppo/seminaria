class SeminarsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :archive, :show, :totem]

  before_action :get_seminar_and_check_permission, only: [:show, :print, :edit, :update, :destroy, :mail_text, :submit_mail_text]

  # Prossimi sono quelli a partire da tutto oggi
  def index
    authorize :seminar
    if params[:only_current_user] && current_user # see config/routes.rb
      @title = "Seminari inseriti da #{current_user.cn}"  
      @seminars = current_user.seminars.order('seminars.date DESC')
    elsif params[:funds_current_user] && current_user
      @title = "Seminari sui miei fondi"
      @fund_ids = current_user.fund_ids
      @seminars = current_user.seminars_on_my_funds_last_year.order('seminars.date DESC')
    elsif current_organization
      @title = "Prossimi seminari del #{current_organization.description}"
      @seminars = current_organization.seminars.order('seminars.date ASC').future
    else
      # TODO
      # redirect_to choose_organization_path and return
      redirect_to seminars_path(__org__: 'mat') and return
    end
    @seminars = @seminars.includes([:documents, :arguments, :place, :zoom_meeting])

    respond_to do |format|
      format.html
      format.json { render json: @seminars }
    end
  end

  # ics formato per ical
  def show
    respond_to do |format|
      format.html 
      format.ics
    end  
  end

  def print
    @no_menu = true
  end

  # archivio quelli da ieri
  def archive
    authorize :seminar
    @year = params[:year] ? params[:year].to_i : Date.today.year
    @seminars = current_organization.seminars.order('seminars.date DESC')
                                             .where("YEAR(date) = ? and date < NOW()", @year)
                                             .includes(:cycle, :serial, :user, :documents, :arguments, repayment: :fund)
  end

  def choose_type
    @cycles  = current_user.cycles.where(organization_id: current_organization.id).all
    @conferences = current_user.conferences.where(organization_id: current_organization.id).all
    @serials = current_organization.serials.order('title asc').active.all
    authorize :seminar
  end

  def new
    # replicate
    if params[:as]
      @as      = Seminar.find(params[:as])
      @seminar = Seminar.new(@as.attributes)
      @seminar.arguments = @as.arguments
    else
      @seminar = current_organization.seminars.new(duration: 60,
                                                   link: 'http://', 
                                                   committee: current_user.cn, 
                                                   date: Date.tomorrow)
    end

    set_seminar_conference_cycle_serial(params)

    authorize @seminar
  end

  def create
    @seminar = current_user.seminars.new(seminar_params)
    @seminar.organization_id = current_organization.id

    @seminar.link = nil if @seminar.link == 'http://'

    set_seminar_conference_cycle_serial(params[:seminar])

    authorize @seminar

    if @seminar.save
      if @seminar.conference_id
        redirect_to conference_path(@seminar.conference_id), notice: "Il seminario è stato creato correttamente."
      else
        # ask for where
        redirect_to edit_seminar_path(@seminar, what: :where), notice: "Il seminario è stato creato correttamente."
      end
    else
      render action: :new
    end
  end

  def edit
    @what = params[:what]
    @repayment = @seminar.repayment
    # user can change existing repayment. FIXME
    @too_late_for_repayment = user_too_late_for_repayment?(@seminar) unless @seminar.repayment

    @serial     = @seminar.serial 
    @cycle      = @seminar.cycle
    @conference = @seminar.conference
    @documents  = @seminar.documents
  end

  def update
    create_zoom = params[:seminar].delete(:zoom_meeting_create)
    if @seminar.update(seminar_params)
      if create_zoom == "1"
        @zoom = ZoomOauth.new
        redirect_to @zoom.authorize_url(@seminar.id)
      else
        redirect_to edit_seminar_path(@seminar), notice: "Il seminario è stato aggiornato."
      end
    else
      # TO REFACTOR
      @repayment  = @seminar.repayment
      @serial     = @seminar.serial 
      @conference = @seminar.conference
      @cycle      = @seminar.cycle
      @documents  = @seminar.documents
      @document   = Document.new
      render action: :edit
    end
  end

  def destroy
    if @seminar.destroy
      flash[:notice] = "Il seminario è stato cancellato."
    else
      flash[:error] = "Non è stato possibile eliminare il seminario."
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
      flash[:notice] = "La mail è stata inviata correttamente."
    else
      flash[:error] = "Errore nell'invio della mail."
    end
    redirect_to seminar_path(@seminar)
  end

  private 

  def get_seminar_and_check_permission
    begin
      @seminar = current_organization.seminars.find(params[:id])
      authorize @seminar
    rescue ActiveRecord::RecordNotFound
      redirect_to seminars_path, alert: 'Seminario non presente in archivio.'
    end
  end

  def seminar_params
    if params[:seminar][:date]
      params[:seminar][:date] = params[:seminar][:date] + " " + params[:seminar].delete('date(4i)') + ':' + params[:seminar].delete('date(5i)')
    end
    p = [:date, :duration, :in_presence, :on_line, :meeting_url, :meeting_code, # :meeting_visible, 
         :place_id, :place_description, :speaker_title, :speaker, :speaker_on_line, 
         :committee, { argument_ids: [] }, :title, :abstract, :file, :link, :link_text, 
         :serial_id, :cycle_id, :conference_id] # FIXME :serial_id, :cycle_id, :conference_id
    p = p + [:user_id, :serial_id, :cycle_id] if policy(current_organization).manage?
    params[:seminar].permit(p)
  end

  def set_seminar_conference_cycle_serial(p)
    if p[:cycle_id] && p[:cycle_id].to_i > 0
      @cycle = current_organization.cycles.find(p[:cycle_id])
      @seminar.cycle_id = @cycle.id
      @seminar.committee = @cycle.committee
    elsif p[:serial_id] && p[:serial_id].to_i > 0
      @serial = current_organization.serials.find(p[:serial_id])
      @seminar.serial_id = @serial.id
    elsif p[:conference_id] && p[:conference_id].to_i > 0
      @conference = current_organization.conferences.find(p[:conference_id])
      @seminar.title = "Relazione all'interno del convegno: #{@conference.title}"
      @seminar.conference_id = @conference.id
      @seminar.date = @conference.start_date
    end
  end
end
