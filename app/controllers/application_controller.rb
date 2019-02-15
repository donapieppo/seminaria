class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper # current_organization

  impersonates :user

  before_action :log_current_user, :set_organization, :redirect_unsigned_user

  # rewrite in order to force sign_in for repayments
  # (clicked in mails)
  def redirect_unsigned_user
    if ! user_signed_in?
      if controller_name == 'repayments'
        session[:original_request] = request.fullpath
        redirect_to auth_shibboleth_callback_path 
      else
        redirect_to root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
      end
    end
  end

  # no security hidden. 
  # We set organization with params[:__org__] as organization_id in config/routes
  def set_organization
    session[:oid] = params[:__org__].to_i if params[:__org__]
    session[:oid] ||= 1
    @current_organization = Organization.find(session[:oid].to_i)
  end
end
