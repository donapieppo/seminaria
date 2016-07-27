class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include DmUniboCommon::Controllers::Helpers
  include UserPermissionHelper

  impersonates :user

  before_filter :log_current_user, :redirect_unsigned_user

  helper_method :user_is_holder?

  # rewrite in order to force sign_in for repayments
  # (clicked in mails)
  def redirect_unsigned_user
    if ! user_signed_in?
      if controller_name == 'repayments'
        session[:original_request] = request.fullpath
        redirect_to user_omniauth_authorize_path(:shibboleth) and return
      else
        redirect_to root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
        return
      end
    end
  end

end
