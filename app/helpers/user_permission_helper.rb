module UserPermissionHelper
  # def user_is_manager?
  # def user_is_admin?
  # def user_is_publisher?
  # def user_is_commissiner?
  [:manager, :admin, :publisher, :commissioner].each do |m|
    define_method "user_is_#{m}?" do
      current_user and current_user.send("is_#{m}?")
    end
    define_method "user_is_#{m}!" do
      (current_user and current_user.send("is_#{m}?")) or redirect_home_with_error
    end
  end

  def user_is_commissioner_or_publisher!
    (user_is_commissioner? or user_is_publisher?) or redirect_home_with_error
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

  def user_can_edit_repayment?(repayment)
    user_is_manager? and return true
    user_owns?(repayment.seminar) and ! repayment.notified 
  end

  def user_can_choose_fund?(repayment)
    user_is_manager? and return true
    user_is_holder?(repayment)
  end
end
