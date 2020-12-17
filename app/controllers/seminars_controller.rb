class SeminarsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :archive, :show, :totem]

  before_action :get_seminar_and_check_permission, only: [:show, :edit, :update, :destroy, :mail_text, :submit_mail_text]

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
    if params[:cycle_id]
      @cycle = current_organization.cycles.find(params[:cycle_id])
      @seminar.cycle_id = @cycle.id
      @seminar.committee = @cycle.committee
    elsif params[:serial_id]
      @serial = current_organization.serials.find(params[:serial_id])
      @seminar.serial_id = @serial.id
    end
    authorize @seminar
  end

  def create
    @seminar = current_user.seminars.new(seminar_params)
    @seminar.organization_id = current_organization.id

    @seminar.link = nil if @seminar.link == 'http://'

    @seminar.cycle_id  = params[:cycle_id] if params[:cycle_id]
    @seminar.serial_id = params[:serial_id] if params[:serial_id]

    authorize @seminar

    if @seminar.save
      redirect_to edit_seminar_path(@seminar, what: :where), notice: "Il seminario è stato creato correttamente."
    else
      render action: :new
    end
  end

  def edit
    @what = params[:what]
    @repayment = @seminar.repayment
    # user can change existing repayment. FIXME
    @too_late_for_repayment = user_too_late_for_repayment?(@seminar) unless @seminar.repayment

    @serial    = @seminar.serial 
    @cycle     = @seminar.cycle
    @documents = @seminar.documents
  end

  def update
    create_zoom = params[:seminar].delete(:zoom_meeting_create)
    if @seminar.update_attributes(seminar_params)
      if create_zoom == "1"
        @zoom = ZoomOauth.new
        redirect_to @zoom.authorize_url(@seminar.id)
      else
        redirect_to edit_seminar_path(@seminar), notice: "Il seminario è stato aggiornato."
      end
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
    p = [:date, :duration, :in_presence, :on_line, :meeting_url, :meeting_code, :meeting_visible, :place_id, :place_description, :cycle_id, :serial_id, :speaker_title, :speaker, :committee, { argument_ids: [] }, :title, :abstract, :file, :link, :link_text]
    p = p + [:user_id, :serial_id, :cycle_id] if policy(current_organization).manage?
    params[:seminar].permit(p)
  end

end
