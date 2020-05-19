# rewrite in order to force sign_in for repayments
# (clicked in mails)
module DmUniboCommon
  module Controllers
    module Helpers
      def redirect_unsigned_user
        if ! user_signed_in?
          if controller_name == 'repayments'
            session[:original_request] = request.fullpath
            redirect_to dm_unibo_common.auth_shibboleth_callback_path 
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

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper

  impersonates :user

  before_action :log_current_user, :set_locale, :set_organization, :redirect_unsigned_user, :update_current_user_authlevels
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  def set_locale
    I18n.locale = :it
  end

  def default_url_options(_options={})
    _options[:__org__] = current_organization ? current_organization.code : nil
    _options
  end
end
