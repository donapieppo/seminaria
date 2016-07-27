class CyclesController < ApplicationController
  skip_filter :redirect_unsigned_user, only: :show

  before_filter :get_cycle_and_check_permission, only: [:edit, :update]

  def index
    @cycles = Cycle.order('id desc').all
  end

  def show
    @cycle = Cycle.find(params[:id])
    @seminars = @cycle.seminars.includes([:documents, :arguments]).order('seminars.date DESC')
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = current_user.cycles.new(cycle_params)
    if @cycle.save
      redirect_to new_cycle_seminar_path(@cycle), notice: "Il ciclo di seminari è stato creato correttamente."
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @cycle.update_attributes(cycle_params)
      redirect_to choose_type_seminars_path, notice: "Il ciclo di seminari è stato aggiornato."
    else
      render action: :edit
    end
  end

  private

  def cycle_params
    params.require(:cycle).permit(:title, :description, :committee)
  end

  def get_cycle_and_check_permission
    @cycle = Cycle.find(params[:id])
    user_owns!(@cycle) 
  end
end


