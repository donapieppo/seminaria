class FundPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.authorization.can_manage?(@record.organization_id)
  end

  def update?
    @user.authorization.can_manage?(@record.organization_id)
  end

  def destroy?
    update?
  end
end
