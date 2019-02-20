class AuthorizationsController < ApplicationController
  before_action :check_cesia!

  def index
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @users = User.order('users.surname, users.name')

    @authorization = @organization.authorizations.new
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @organization.authorizations.create(user_id: params[:authorization][:user_id], 
                                        authlevel: params[:authorization][:authlevel])
    redirect_to authorizations_path, notice: 'OK'
  end

  def destroy
  end

  private

  def check_cesia!
    current_user.is_cesia? or raise
  end
end
