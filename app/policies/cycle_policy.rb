class CyclePolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    true
  end

  def create?
    @user 
  end

  def update?
    @user and (@user.authorization.can_manage?(@record.organization_id) or record.user_id == @user.id)
  end

  def destroy?
    update?
  end
end

