class HighlightsController < ApplicationController
  # uniche pagine da vedere senza essere loggati
  # index solitamente non si raggiunge perchè index è in home con insieme seminari e highlights
  skip_before_action :redirect_unsigned_user, only: [:index, :archive]

  before_action :user_is_commissioner_or_publisher!, except: [:index, :archive, :new, :create]
  before_action :user_is_publisher!,                   only: [:publish, :refuse]

  before_action :get_highlight_and_permission, only: [:edit, :update]

  before_action :history_log, only: [:create, :update, :publish, :refuse]

  def index
    if params[:only_current_user] and current_user
      @highlights = current_user.highlights.order('highlights.created_at DESC')
    else
      @highlights = Highlight.priorized
    end
  end

  def admin
    if params[:refused] 
      @highlights = Highlight.refused
    elsif params[:published]
      @highlights = Highlight.approved
    else
      @highlights = Highlight.unrefused.unapproved
    end
    @highlights = @highlights.includes(:approvals).order(:created_at)
  end

  def new
    @highlight = current_user.highlights.new(link: 'http://', 
                                             proponent: current_user.cn, 
                                             visible_from: Date.today + 1.day, 
                                             visible_to: Date.today + 2.week)
  end

  def edit
  end

  def create
    @highlight = current_user.highlights.new(highlight_params)
    if @highlight.save
      if HighlightMailer.notify_highlight_to_commissioners(@highlight).deliver
        flash[:notice] = "La notizia è stata creata e inoltrata alla commissione."
      else
        flash[:notice] = "La notizia è stata creata MA CI SONO STATI PROBLEMI A INOLTRARLA VIA MAIL ALLA COMMISSIONE"
      end
      redirect_to user_highlights_path and return
    else
      render action: :new
    end
  end

  def update
    if @highlight.update_attributes(highlight_params)
      flash[:notice] = "Il contenuto della notizia è stato aggiornato"
      redirect_to user_highlights_path
    else
      render action: :edit
    end
  end

  def publish
    @highlight = Highlight.find(params[:id])
    if @highlight.publish(params[:priority])
      flash[:notice] = "La notizia è stata pubblicata"
      redirect_to highlights_path and return
    else
      flash[:error] = "Non è stato possibile pubblicare la notizia"
      redirect_to edit_highlight_path(@highlight) and return
    end
  end

  # riorda che il refuse implica approved_at => nil
  def refuse
    @highlight = Highlight.find(params[:id])
    @highlight.refuse
    redirect_to highlights_path
  end

  def archive
    @year = params[:year] ? params[:year].to_i : Date.today.year
    @highlights = Highlight.order('highlights.visible_from DESC').where("YEAR(approved_at) = ? and approved_at < CURDATE()", @year)
  end

  private 

  def history_log
    logger.info("Highlight change: #{current_user.upn}: #{params.inspect}")
  end

  def highlight_params
    params[:highlight].permit(:proponent, :name, :description, :date, :priority, :visible_from, :visible_to, :link, :link_text, { tag_ids: [] })
  end

  # FIXME decidere se utente puo' modificare!!!
  # before_action :user_is_commissioner_or_publisher! per ora impedisce
  def get_highlight_and_permission
    @highlight = Highlight.find(params[:id])
    if !((user_owns?(@highlight) and @highlight.under_evaluation?) or user_is_publisher?)
      flash[:error]= "Non è possibile modificare i dati di questa notizia"
      redirect_to root_path and return
    end
  end
end

