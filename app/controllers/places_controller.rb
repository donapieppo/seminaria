class PlacesController < ApplicationController
  before_action :get_place_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @places = current_organization.places
    authorize Place
  end

  def show
    @place = Place.find(params[:id])
    authorize @place
    @seminars = @place.seminars.this_year.order('date desc').includes(:organization)
  end

  def new
    @place = current_organization.places.new
    authorize @place
  end

  def create
    @place = current_organization.places.new(name: params[:place][:name])
    authorize @place
    if @place.save
      redirect_to places_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @place.update_attributes(name: params[:place][:name])
      redirect_to places_path
    else
      render :edit
    end
  end

  private

  def get_place_and_check_permission
    @place = Place.find(params[:id])
    authorize @place
  end
end
