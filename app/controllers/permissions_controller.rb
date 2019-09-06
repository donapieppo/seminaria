class PermissionsController < ApplicationController
  before_action :check_cesia!

  def index
    skip_authorization
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @users = User.order('users.surname, users.name')

    @permission = @organization.permissions.new
    authorize @permission
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @permission = @organization.permissions.new(user_id: params[:permission][:user_id], 
                                                authlevel: params[:permission][:authlevel])
    authorize @permission
    if @permission.save
      redirect_to permissions_path, notice: 'OK'
    else
      render :new
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    authorize @permission
    if @permission.destroy
      flash[:notice] = "OK."
    else
      flash[:error] = "Non è stato possibile eliminare l'autorizzazione."
    end
    redirect_to permissions_path
  end

  private

  def check_cesia!
    current_user.is_cesia? or raise
  end
end
