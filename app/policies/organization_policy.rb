class OrganizationPolicy < ApplicationPolicy
  # FIXME
  def see?
    @user and @user.is_cesia?
  end

  def manage?
    @user and @user.is_cesia?
  end

  def admin?
    @user and @user.is_cesia?
  end
end
