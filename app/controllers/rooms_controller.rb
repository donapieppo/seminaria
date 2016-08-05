class RoomsController < ApplicationController
  before_action :get_room_and_check_permission, only: [:edit, :update, :destroy]

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path, notice: "OK"
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  private 

  def set_room_and_check_permission
  end

  def room_params
    params[:room].permit(:name, :place_id)
  end
end


