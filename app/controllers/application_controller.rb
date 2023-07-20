# rewrite in order to force sign_in for repayments
# (clicked in mails)
module DmUniboCommon
  module Controllers
    module Helpers
      def redirect_unsigned_user
        if !user_signed_in?
          if controller_name == "repayments"
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

class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user,
    :update_authorization,
    :set_current_organization,
    :after_current_user_and_organization,
    :log_current_user,
    :set_locale,
    :redirect_unsigned_user

  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  include UserPermissionHelper

  def set_locale
    I18n.locale = :it
  end
end
