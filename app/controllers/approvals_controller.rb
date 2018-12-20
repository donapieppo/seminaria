class ApprovalsController < ApplicationController
  before_action :user_is_commissioner!
  before_action :get_approval_and_highlight_and_check_permission, only: [:edit, :update]

  before_action :history_log, :only => [:create, :update]

  def new
    @highlight = Highlight.find(params[:highlight_id])
    @approval = @highlight.approvals.new
  end

  def edit
  end

  # verifichiamo di non avere altri approvals a nostro nome, altrimenti li aggiorniamo
  def create
    @highlight = Highlight.find(params[:highlight_id])
    raise_if_highlight_concluded(@highlight)

    @approval = @highlight.approvals.where(:user_id => current_user.id).first || @highlight.approvals.new
    @approval.assign_attributes(approval_params)
    @approval.user_id = current_user.id

    if @approval.save
      redirect_to admin_highlights_path, notice: "Il tuo parere è stato correttamente registrato."
    else
      render :action => :edit
    end
  end

  def update
    if @approval.update_attributes(approval_params)
      redirect_to admin_highlights_path, notice: "Il tuo parere è stato correttamente aggiornato."
    else
      render :action => :edit
    end
  end


  private 

  def history_log
    logger.info("Approval change: #{current_user.upn}: #{params.inspect}")
  end

  def raise_if_highlight_concluded(highlight)
    (highlight.approved? or highlight.refused?) and raise ("No action on this highlight. Concluded")
  end

  def get_approval_and_highlight_and_check_permission
    @approval = Approval.find(params[:id])
    @highlight = @approval.highlight
    user_owns?(@approval) or raise "NON TUO"
    raise_if_highlight_concluded(@highlight)
  end

  def approval_params
    logger.info("#{current_user.upn}: #{params.inspect}")
    params[:approval].permit(:judgment, :justification)
  end

end

