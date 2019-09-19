class OrganizationPolicy < ApplicationPolicy
  def read?
    @user and @user.authorization.can_read?(@record)
  end

  def manage?
    @user and @user.authorization.can_manage?(@record)
  end
end
