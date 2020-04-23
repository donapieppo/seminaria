class ArgumentPolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    true
  end

  def create?
    record_organization_manager?
  end

  def update?
    record_organization_manager?
  end

  def destroy?
    update?
  end
end

