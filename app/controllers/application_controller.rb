# rewrite in order to force sign_in for repayments
# (clicked in mails)
module DmUniboCommon
  module Controllers
    module Helpers
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
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper # current_organization

  impersonates :user

  before_action :log_current_user, :set_locale, :set_organization, :redirect_unsigned_user, :retrive_authlevels

  def set_locale
    I18n.locale = :it
  end

  # no security hidden. 
  # We set organization with params[:__org__] as organization_id in config/routes
  def set_organization
    if params[:__org__]
      session[:oid] = params[:__org__].to_i 
    end
    # fallback to default organization
    session[:oid] ||= 1

    @current_organization = Organization.find(session[:oid].to_i)
    if current_user
      current_user.current_organization = @current_organization
    end
  end

  def retrive_authlevels
    if current_user
      current_user.authorization = Authorization.new(request.remote_ip, current_user)
    end
  end
end
