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
    owner_or_organization_manager?
  end

  def destroy?
    update?
  end
end

