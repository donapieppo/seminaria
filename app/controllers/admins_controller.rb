class AdminsController < ApplicationController
  before_action :user_cesia!

  def index
    @admins = Hash.new
    Admin.includes(:organization, :user).order('organizations.name').each do |admin|
      @admins[admin.organization] ||= []
      @admins[admin.organization] << admin
    end
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @admin = @organization.admins.new
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @admin = @organization.admins.new(admin_params)
    if @admin.save
      redirect_to organization_path(@organization), notice: "Amministratore aggiunto alla struttura #{@organization.name}."
    else
      render :new
    end
  end

  def destroy
    admin = Admin.find(params[:id])
    admin.destroy and flash[:notice] = 'Amministratore cancellato correttamente.'
    redirect_to root_path
  end

  private

  def admin_params
    params[:admin].permit(:user_upn)
  end
end


