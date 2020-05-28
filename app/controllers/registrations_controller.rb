class RegistrationsController < ApplicationController
  skip_before_action :redirect_unsigned_user
  before_action :get_seminar, only: [:index, :new, :create]

  def index
    @registrations = @seminar.registrations
    @url = @seminar.zoom_meeting ? @seminar.zoom_meeting.join_url : @seminar.meeting_url
    authorize @seminar, :update?
  end

  def new
    @registration = @seminar.registrations.new
    authorize @registration
    if current_user
      @registration.user_id = current_user.id
      @registration.save!
      redirect_to root_path, notice: "Sei stato registrato, riceverai una mail con le istruzioni per accedere il giorno del seminario."
    end
  end

  def create
    @registration = @seminar.registrations.new(registration_params)
    @registration.user_id = current_user.id if current_user
    authorize @registration
    if @registration.save
      session[Registration.session_name(@seminar)] = 1
      redirect_to root_path, notice: "Sei stato registrato, riceverai una mail con le istruzioni per accedere il giorno dl seminario."
    else
      render action: 'new'
    end
  end

  def destroy
    registration = Registration.find(params[:id])
    authorize registration
    if registration.destroy
      flash[:notice] = 'La registrazione è stata cancellata.'
    end
    redirect_to seminars_path
  end

  private

  def registration_params
    params[:registration].permit(:email, :name, :surname, :affiliation)
  end

  def get_seminar
    @seminar = Seminar.find(params[:seminar_id])
  end
end
