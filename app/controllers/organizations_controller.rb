class OrganizationsController < ApplicationController
  before_action :user_cesia!, except: [:show]
  before_action :set_organization, only: [:edit, :update, :destroy]

  def index
    @organizations = Organization.order(:name).all
  end

  # solo cesia puo' vedere altro che current_organization
  def show
    @organization = Organization.find(params[:id]) 
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to organizations_path, notice: 'La struttura è stata creata.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @organization.update_attributes(organization_params)
    redirect_to organizations_path, notice: 'La struttura è stata aggiornata.'
  end

  private

  def organization_params
    params[:organization].permit(:name, :description)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end

