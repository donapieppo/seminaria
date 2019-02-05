class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper
  include Pundit

  impersonates :user

  before_action :log_current_user, :redirect_unsigned_user

  # rewrite in order to force sign_in for repayments
  # (clicked in mails)
  def redirect_unsigned_user
    if ! user_signed_in?
      if controller_name == 'repayments'
        session[:original_request] = request.fullpath
        # redirect_to user_omniauth_authorize_path(:shibboleth) and return
        # redirect_to omniauth_authorize_path(:user, :shibboleth) and return
        redirect_to auth_shibboleth_callback_path and return
      else
        redirect_to root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
        return
      end
    end
  end

end
