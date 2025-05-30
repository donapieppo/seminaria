class SerialsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :show]

  before_action :get_serial_and_check_permission, only: [:show, :edit, :update]

  def index
    authorize :serial
    @serials = current_organization.serials.order("serials.active desc, serials.title asc")
  end

  def show
    @seminars = @serial.seminars.future.includes(:repayment, :documents, :arguments).order("seminars.date ASC")
    @archive = @serial.seminars.past.includes(:repayment, :documents, :arguments).order("seminars.date DESC")
  end

  def new
    @serial = current_organization.serials.new(active: true)
    authorize @serial
  end

  def create
    @serial = current_organization.serials.new(serial_params)
    authorize @serial
    if @serial.save
      redirect_to serials_path, notice: "La serie è stata creata correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @serial.update(serial_params)
      redirect_to serials_path, notice: "La serie è stata aggiornata correttamente."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def get_serial_and_check_permission
    @serial = current_organization.serials.find(params[:id])
    authorize @serial
  end

  def serial_params
    params.require(:serial).permit(:title, :description, :committee, :link, :active)
  end
end
