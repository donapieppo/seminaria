class OrganizationPolicy < ApplicationPolicy
  # FIXME
  def see?
    @user and @user.authorization.can_manage?(@record)
  end

  def manage?
    @user and @user.authorization.can_manage?(@record)
  end

  def admin?
    @user and @user.authorization.can_admin?(@record)
  end
end
