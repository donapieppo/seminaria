class PermissionPolicy < ApplicationPolicy
  # only superuser
  def create?
    @user.is_cesia?
  end

  # only superuser
  def update?
    create?
  end

  def destroy?
    update?
  end
end
