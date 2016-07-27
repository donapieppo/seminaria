class SerialsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :show]
  before_action      :user_is_admin!,       except: [:index, :show]

  before_action :get_serial, only: [:show, :edit, :update]

  def index
    @serials = Serial.order('serials.active desc, serials.title asc')
  end

  def show
    @seminars = @serial.seminars.includes([:documents, :arguments]).order('seminars.date DESC')
  end

  def new
    @serial = Serial.new
  end

  def create
    @serial = Serial.new(serial_params)
    if @serial.save
      redirect_to serials_path, notice: "Serie creata correttamente"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @serial.update_attributes(serial_params)
      redirect_to serials_path, notice: "Serie aggiornata correttamente"
    else
      render :action => :edit
    end
  end

  private

  def get_serial
    @serial = Serial.find(params[:id])
  end

  def serial_params
    params.require(:serial).permit(:title, :description, :committee, :link, :active)
  end

end

