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

  def user_is_holder?(seminar)
    (current_user and seminar.repayment and ! seminar.repayment.new_record?) or return false
    seminar.repayment.holder_id == current_user.id or current_user.is_admin?
  end

  def redirect_home_with_error
    redirect_to root_path, alert: "Non avete diritti sufficienti per accedere alla pagina richiesta."
  end
end
