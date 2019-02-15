class AuthorizationsController < ApplicationController
  before_action :check_cesia!

  def index
    @authorizations = Authorization.includes(:user, :organization).order('users.surname, users.name')
  end

  def new
    @users = User.order('users.surname, users.name')
    @organizations = Organization.order(:name)
    @authorization = Authorization.new
  end

  def create
    Authorization.create(user_id: params[:authorization][:user_id], 
                         organization_id: params[:authorization][:organization_id],
                         authlevel: params[:authorization][:authlevel])
    redirect_to authorizations_path
  end

  def destroy
  end

  private

  def check_cesia!
    current_user.is_cesia? or raise
  end
end
