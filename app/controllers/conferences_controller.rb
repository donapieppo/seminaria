class ConferencesController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: :show

  before_action :get_conference_and_check_permission, only: [:edit, :update]

  def index
    @conferences = current_organization.conferences.order('id desc').includes(:seminars).all
    authorize Conference
  end

  def show
    @conference = current_organization.conferences.find(params[:id])
    authorize @conference
    @seminars = @conference.seminars.order('seminars.date DESC')
  end

  def new
    @conference = current_organization.conferences.new
    authorize @conference
  end

  def create
    @conference = current_user.conferences.new(conference_params)
    @conference.organization = current_organization
    authorize @conference

    if @conference.save
      redirect_to new_conference_seminar_path(@conference), notice: "Il convegno è stato creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @conference.update(conference_params)
      redirect_to choose_type_seminars_path, notice: "Il convegno è stato aggiornatocorrettamente."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def conference_params
    params.require(:conference).permit(:title, :abstract, :committee, :start_date, :end_date, :url)
  end

  def get_conference_and_check_permission
    @conference = current_organization.conferences.find(params[:id])
    authorize @conference
  end
end


