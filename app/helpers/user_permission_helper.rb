module UserPermissionHelper

  def current_organization
    @current_organization
  end

  def user_is_manager?
    current_user and current_user.can_manage?(current_organization)
  end

  def user_is_admin?
    current_user and current_user.can_admin?(current_organization)
  end

  def user_is_manager!
    user_is_admin? or raise DmUniboCommon::NoAccess
  end

  def user_is_admin!
    user_is_manager? or raise DmUniboCommon::NoAccess
  end

  def user_is_holder?(what)
    current_user or return false
    case what
    when Repayment
      what.new_record? and return false
      what.holder_id == current_user.id
    when Seminar
      user_is_holder?(what.repayment)
    else
      false
    end
  end

  # FIXME
  def user_too_late_for_repayment?(seminar)
    user_is_manager? and return false
    seminar.too_late_for_repayment? 
  end

  def redirect_home_with_error
    redirect_to root_path, alert: "Non avete diritti sufficienti per accedere alla pagina richiesta."
  end

end
