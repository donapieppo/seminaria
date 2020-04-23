class SerialPolicy < ApplicationPolicy
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
    create?
  end

  def destroy?
    update?
  end
end

