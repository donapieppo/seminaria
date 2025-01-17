# rewrite in order to force sign_in for repayments
# (clicked in mails)
module DmUniboCommon
  module Controllers
    module Helpers
      def redirect_unsigned_user
        if !user_signed_in?
          if controller_name == "repayments"
            session[:original_request] = request.fullpath
            # dm_unibo_common.auth_callback_path
            # redirect_to dm_unibo_common.auth_entra_id_callback_path
            # redirect_to dm_unibo_common.send(:"auth_#{Rails.configuration.unibo_common.omniauth_provider}_callback_path")
            redirect_to root_path, alert: "È necessario loggarsi prima di accedere alla pagine dei compensi."
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

  include UserPermissionHelper

  def set_locale
    I18n.locale = :it
  end
end
