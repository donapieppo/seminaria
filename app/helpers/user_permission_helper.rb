module UserPermissionHelper

  # see app/policies/application_policy.rb
  def user_is_manager?
    current_user && current_organization && current_user.authorization.can_manage?(current_organization)
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
end
