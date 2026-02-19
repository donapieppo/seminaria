class CyclesController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: :show

  before_action :get_cycle_and_check_permission, only: [:edit, :update]

  def index
    @cycles = current_organization.cycles.order("id DESC").includes(:seminars).all
    authorize Cycle
  end

  def show
    @cycle = current_organization.cycles.find(params[:id])
    authorize @cycle
    @seminars = @cycle.seminars.includes(:documents, :arguments, :repayment).order("seminars.date DESC")
  end

  def new
    @cycle = Cycle.new(organization: current_organization)
    authorize @cycle
  end

  def create
    @cycle = current_user.cycles.new(cycle_params)
    @cycle.organization = current_organization
    authorize @cycle

    if @cycle.save
      redirect_to new_cycle_seminar_path(@cycle), notice: "Il ciclo di seminari è stato creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cycle.update(cycle_params)
      redirect_to choose_type_seminars_path, notice: "Il ciclo di seminari è stato aggiornato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def cycle_params
    params.require(:cycle).permit(:title, :description, :committee)
  end

  def get_cycle_and_check_permission
    @cycle = Cycle.find(params[:id])
    authorize @cycle
  end
end


